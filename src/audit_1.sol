// Educational Smart Contract Example with Vulnerabilities
// Edwin Anajemba
pragma solidity ^0.8.0;

contract VulnerableToken {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function mint(uint256 amount) public {
        // Vulnerability: No access control, anyone can mint tokens.
        balances[msg.sender] += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function transfer(address to, uint256 value) public returns (bool) {
        // Functionality: Transfer tokens
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        // Functionality: Approve spending allowance
        allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        // Functionality: Transfer tokens from another account
        require(balances[from] >= value, "Insufficient balance");
        require(allowances[from][msg.sender] >= value, "Insufficient allowance");
        balances[from] -= value;
        balances[to] += value;
        allowances[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function getBalance(address account) public view returns (uint256) {
        // Functionality: Get token balance
        return balances[account];
    }

    // Intentional Vulnerability: No withdrawal limit
    function withdraw() public {
        require(balances[msg.sender] > 0, "No balance to withdraw");
        payable(msg.sender).transfer(balances[msg.sender]);
        balances[msg.sender] = 0;
    }

    // Intentional Vulnerability: Self-destruct
    function destroy() public {
        // Vulnerability: Anyone can destroy the contract, leading to loss of funds.
        selfdestruct(payable(msg.sender));
    }
}
