// Educational Smart Contract Example for Company 2 with Vulnerabilities
// Wale Oladeinde
pragma solidity ^0.8.0;

contract VulnerableCrowdsale {
    address public owner;
    mapping(address => uint256) public contributions;
    mapping(address => bool) public whitelist;

    event Contribution(address indexed contributor, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addToWhitelist(address account) public onlyOwner {
        whitelist[account] = true;
    }

    function contribute() public payable {
        // Vulnerability: No check for whitelisted contributors.
        require(whitelist[msg.sender], "Contributor not whitelisted");
        
        // Functionality: Accept contributions
        contributions[msg.sender] += msg.value;
        emit Contribution(msg.sender, msg.value);
    }

    // Intentional Vulnerability: Insecure fund withdrawal
    function withdrawFunds() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // Intentional Vulnerability: Owner can change ownership to any address
    function changeOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    // Intentional Vulnerability: Self-destruct
    function destroy() public onlyOwner {
        // Vulnerability: Anyone can destroy the contract, leading to loss of funds.
        selfdestruct(payable(owner));
    }
}
