// Educational Smart Contract Example for Company 7 with Additional Vulnerabilities
// Joshua Iluma
pragma solidity 0.8.0;

contract VulnerableEscrow {
    address public owner;
    mapping(address => uint256) public deposits;
    mapping(address => bool) public allowedParticipants;
    uint256 public totalDeposits;

    event Deposit(address indexed depositor, uint256 amount);
    event Withdrawal(address indexed participant, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    modifier onlyParticipant() {
        require(allowedParticipants[msg.sender], "Not an allowed participant");
        _;
    }

    constructor(address[] memory participants) {
        owner = msg.sender;
        totalDeposits = 0;

        for (uint256 i = 0; i < participants.length; i++) {
            allowedParticipants[participants[i]] = true;
        }
    }

    function deposit() public payable {
        // Functionality: Deposit funds
        deposits[msg.sender] += msg.value;
        totalDeposits += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function requestWithdrawal(uint256 amount) public onlyParticipant {
        // Intentional Vulnerability: No check for individual participant balances
        require(amount <= totalDeposits, "Insufficient total balance");

        // Functionality: Request withdrawal
        payable(msg.sender).transfer(amount);
        totalDeposits -= amount;
        emit Withdrawal(msg.sender, amount);
    }

    // Functionality: Get the balance of an individual participant
    function getBalance() public view returns (uint256) {
        return deposits[msg.sender];
    }

    // Intentional Vulnerability: Owner can change the list of participants
    function changeParticipants(address[] memory newParticipants) public onlyOwner {
        for (uint256 i = 0; i < newParticipants.length; i++) {
            allowedParticipants[newParticipants[i]] = true;
        }
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
