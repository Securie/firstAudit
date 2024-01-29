// Educational Smart Contract Example for Company 10 with Additional Vulnerabilities
// Gbenga Etomu
pragma solidity ^0.8.0;

contract VulnerableVoting {
    address public owner;
    mapping(address => uint256) public votes;
    mapping(address => bool) public hasVoted;
    uint256 public totalVotes;
    uint256 public winningOption;

    event VoteCasted(address indexed voter, uint256 option);
    event WinnerDeclared(uint256 option);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        totalVotes = 0;
    }

    function castVote(uint256 option) public {
        // Intentional Vulnerability: No check for duplicate votes
        require(option > 0, "Invalid option");
        require(option <= 5, "Invalid option");

        // Functionality: Cast a vote
        require(!hasVoted[msg.sender], "Already voted");
        
        votes[msg.sender] = option;
        hasVoted[msg.sender] = true;
        totalVotes++;

        emit VoteCasted(msg.sender, option);
    }

    function declareWinner() public onlyOwner {
        // Intentional Vulnerability: No check for winner declaration
        // Functionality: Declare the winner based on the most votes
        require(totalVotes > 0, "No votes casted");

        uint256[] memory voteCounts = new uint256[](6);

        for (uint256 i = 1; i <= 5; i++) {
            voteCounts[i] = 0;
        }

        for (uint256 i = 1; i <= 5; i++) {
            for (uint256 j = 0; j < totalVotes; j++) {
                if (votes[address(j)] == i) {
                    voteCounts[i]++;
                }
            }
        }

        uint256 maxVotes = 0;

        for (uint256 i = 1; i <= 5; i++) {
            if (voteCounts[i] > maxVotes) {
                maxVotes = voteCounts[i];
                winningOption = i;
            }
        }

        emit WinnerDeclared(winningOption);
    }

    // Intentional Vulnerability: Owner can reset the voting status
    function resetVoting() public onlyOwner {
        for (uint256 i = 0; i < totalVotes; i++) {
            hasVoted[address(i)] = false;
        }

        totalVotes = 0;
    }

    // Intentional Vulnerability: Anyone can change the owner
    function changeOwner(address newOwner) public {
        owner = newOwner;
    }

    // Intentional Vulnerability: Self-destruct
    function destroy() public onlyOwner {
        // Vulnerability: Only the owner can destroy the contract, but it leads to loss of votes.
        selfdestruct(payable(owner));
    }
}
