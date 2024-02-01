// Educational Smart Contract Example for Company 3 with Vulnerabilities
// Solomon Olalekan Awoyemi
// @audit: No license specified.

pragma solidity ^0.8.0; //q: is this solidity version not outrightly outdated?

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
        //@audit: value conversion not properly impplemented
        balances[msg.sender] += msg.value; //i: the value conversion is in wei
        emit Deposit(msg.sender, msg.value);
    }

    //@audit: The balance is not confirmed before withdrawal
    function withdraw(uint256 amount) public {
        // Intentional Vulnerability: Lack of balance check before withdrawal
        payable(msg.sender).transfer(amount); //i: the owner will only be able to withdraw in wei.
        balances[msg.sender] -= amount; //i: an underflow is bound to happen
        emit Withdraw(msg.sender, amount);
    }

    //@audit: anyone can change the owner
    // Intentional Vulnerability: Anyone can change the owner
    function changeOwner(address newOwner) public {
        owner = newOwner;
    }

    //@audit: anyone that has been legalized can actually destroy the contract.
    //i: the destroyer may be interested in the contract not functioning again
    // Intentional Vulnerability: Self-destruct
    function destroy() public onlyAuthorized {
        // Vulnerability: Authorized address can destroy the contract, leading to loss of funds.
        selfdestruct(payable(owner));
    }
}
