// Educational Smart Contract Example for Company 5 with Additional Vulnerabilities
// Adeola David Adelakun
pragma solidity ^0.8.0;

contract VulnerableTokenSale {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => bool) public whitelisted;
    uint256 public tokenPrice;

    event TokenPurchased(address indexed buyer, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(uint256 _tokenPrice) {
        owner = msg.sender;
        tokenPrice = _tokenPrice;
    }

    function addToWhitelist(address account) public onlyOwner {
        whitelisted[account] = true;
    }

    function purchaseTokens(uint256 numTokens) public payable {
        // Vulnerability: No check for whitelisted buyers.
        require(msg.value >= numTokens * tokenPrice, "Insufficient funds");
        
        // Functionality: Transfer tokens to the buyer
        balances[msg.sender] += numTokens;
        emit TokenPurchased(msg.sender, numTokens);
    }

    // Functionality: Get the balance of tokens for an account
    function getBalance(address account) public view returns (uint256) {
        return balances[account];
    }

    // Intentional Vulnerability: Owner can change the token price
    function changeTokenPrice(uint256 newTokenPrice) public onlyOwner {
        tokenPrice = newTokenPrice;
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
