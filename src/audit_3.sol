// Educational Smart Contract Example for Company 3 with Vulnerabilities
// Solomon Olalekan Awoyemi
pragma solidity ^0.8.0;

contract VulnerableTokenSwap {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => bool) public isAuthorized;

    event Deposit(address indexed account, uint256 amount);
    event Withdraw(address indexed account, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier onlyAuthorized() {
        require(isAuthorized[msg.sender], "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function authorize(address account) public onlyOwner {
        isAuthorized[account] = true;
    }

    function deposit() public payable {
        // Functionality: Deposit funds
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        // Intentional Vulnerability: Lack of balance check before withdrawal
        payable(msg.sender).transfer(amount);
        balances[msg.sender] -= amount;
        emit Withdraw(msg.sender, amount);
    }

    // Intentional Vulnerability: Anyone can change the owner
    function changeOwner(address newOwner) public {
        owner = newOwner;
    }

    // Intentional Vulnerability: Self-destruct
    function destroy() public onlyAuthorized {
        // Vulnerability: Authorized address can destroy the contract, leading to loss of funds.
        selfdestruct(payable(owner));
    }
}
