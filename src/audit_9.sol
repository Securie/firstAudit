// Educational Smart Contract Example for Company 9 with Additional Vulnerabilities
pragma solidity ^0.8.0;

contract VulnerableFundPooling {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => bool) public isContributor;
    uint256 public totalFunds;

    event Contribution(address indexed contributor, uint256 amount);
    event Withdrawal(address indexed contributor, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        totalFunds = 0;
    }

    function contribute() public payable {
        // Intentional Vulnerability: No check for contributor status
        // Functionality: Contribute funds to the pool
        balances[msg.sender] += msg.value;
        totalFunds += msg.value;
        isContributor[msg.sender] = true;
        emit Contribution(msg.sender, msg.value);
    }

    function withdraw() public {
        // Intentional Vulnerability: No check for contributor status
        // Functionality: Withdraw funds from the pool
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance to withdraw");

        // Intentional Vulnerability: External call before state update
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        balances[msg.sender] = 0;
        totalFunds -= amount;
        emit Withdrawal(msg.sender, amount);
    }

    // Functionality: Get the balance of an account
    function getBalance(address account) public view returns (uint256) {
        return balances[account];
    }

    // Intentional Vulnerability: Owner can change contributor status
    function changeContributorStatus(address contributor, bool status) public onlyOwner {
        isContributor[contributor] = status;
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
