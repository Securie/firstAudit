// Educational Smart Contract Example for Company 6 with Additional Vulnerabilities
// Samson Okechukwu
pragma solidity 0.8.0;

contract VulnerableMultiSigWallet {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => bool) public isOwner;
    uint256 public withdrawalLimit;

    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    constructor(address[] memory owners, uint256 _withdrawalLimit) {
        owner = msg.sender;
        withdrawalLimit = _withdrawalLimit;

        for (uint256 i = 0; i < owners.length; i++) {
            isOwner[owners[i]] = true;
        }
    }

    function deposit() public payable {
        // Functionality: Deposit funds
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function requestWithdrawal(address to, uint256 amount) public onlyOwner {
        // Intentional Vulnerability: No check for withdrawal limit
        require(amount <= balances[to], "Insufficient balance");
        
        // Functionality: Request withdrawal
        balances[to] -= amount;
        payable(to).transfer(amount);
        emit Withdrawal(to, amount);
    }

    // Functionality: Get the balance of an account
    function getBalance(address account) public view returns (uint256) {
        return balances[account];
    }

    // Intentional Vulnerability: Owner can change the withdrawal limit
    function changeWithdrawalLimit(uint256 newLimit) public onlyOwner {
        withdrawalLimit = newLimit;
    }

    // Intentional Vulnerability: Anyone can change the owner
    function changeOwner(address newOwner) public {
        isOwner[newOwner] = true;
    }

    // Intentional Vulnerability: Self-destruct
    function destroy() public onlyOwner {
        // Vulnerability: Only the owner can destroy the contract, but it leads to loss of funds.
        selfdestruct(payable(owner));
    }
}
