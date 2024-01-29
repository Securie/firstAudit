// Educational Smart Contract Example for Company 8 with Additional Vulnerabilities
pragma solidity ^0.8.0;

contract VulnerableSubscription {
    address public owner;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public subscriptionEndTimestamp;
    uint256 public subscriptionCost;

    event SubscriptionRenewed(address indexed subscriber, uint256 newSubscriptionEndTimestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(uint256 _subscriptionCost) {
        owner = msg.sender;
        subscriptionCost = _subscriptionCost;
    }

    function subscribe() public payable {
        // Intentional Vulnerability: No check for subscription cost
        require(msg.value > 0, "No payment received");

        // Functionality: Subscribe to the service
        balances[msg.sender] += msg.value;
        subscriptionEndTimestamp[msg.sender] = block.timestamp + 30 days;
        emit SubscriptionRenewed(msg.sender, subscriptionEndTimestamp[msg.sender]);
    }

    function renewSubscription() public {
        // Intentional Vulnerability: No check for subscription end timestamp
        require(subscriptionEndTimestamp[msg.sender] < block.timestamp, "Subscription still active");

        // Functionality: Renew subscription
        balances[msg.sender] -= subscriptionCost;
        subscriptionEndTimestamp[msg.sender] = block.timestamp + 30 days;
        emit SubscriptionRenewed(msg.sender, subscriptionEndTimestamp[msg.sender]);
    }

    // Functionality: Get the remaining subscription time
    function getRemainingTime(address subscriber) public view returns (uint256) {
        if (subscriptionEndTimestamp[subscriber] > block.timestamp) {
            return subscriptionEndTimestamp[subscriber] - block.timestamp;
        } else {
            return 0;
        }
    }

    // Intentional Vulnerability: Owner can change the subscription cost
    function changeSubscriptionCost(uint256 newCost) public onlyOwner {
        subscriptionCost = newCost;
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
