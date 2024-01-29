// Educational Smart Contract Example for Company 4 with Additional Vulnerabilities
pragma solidity ^0.8.0;

contract VulnerableAuction {
    address public owner;
    mapping(address => uint256) public bids;
    uint256 public highestBid;
    address public highestBidder;
    uint256 public reservePrice;
    bool public auctionEnded;

    event Bid(address indexed bidder, uint256 amount);
    event AuctionEnded(address indexed winner, uint256 winningAmount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(uint256 _reservePrice) {
        owner = msg.sender;
        reservePrice = _reservePrice;
    }

    function placeBid() public payable {
        require(!auctionEnded, "Auction has ended");

        // Functionality: Place a bid
        require(msg.value > highestBid, "Bid must be higher than the current highest bid");

        // Vulnerability: Reentrancy vulnerability in the highest bidder's transfer.
        if (highestBidder != address(0)) {
            // Intentional vulnerability: External call before state update.
            (bool success, ) = highestBidder.call{value: highestBid}("");
            require(success, "Transfer failed");
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        bids[msg.sender] += msg.value;
        emit Bid(msg.sender, msg.value);
    }

    // Functionality: End the auction
    function endAuction() public onlyOwner {
        require(!auctionEnded, "Auction already ended");
        require(highestBid >= reservePrice, "Reserve price not met");

        auctionEnded = true;
        emit AuctionEnded(highestBidder, highestBid);
    }

    // Functionality: Get current highest bid
    function getHighestBid() public view returns (uint256) {
        return highestBid;
    }

    // Intentional Vulnerability: Owner can change the reserve price
    function changeReservePrice(uint256 newReservePrice) public onlyOwner {
        reservePrice = newReservePrice;
    }

    // Intentional Vulnerability: Anyone can change the owner
    function changeOwner(address newOwner) public {
        owner = newOwner;
    }

    // Intentional Vulnerability: Self-destruct
    function destroy() public onlyOwner {
        // Vulnerability: Only the owner can destroy the contract, but it leads to loss of funds.
        selfdestruct(payable(owner));
    }
}
