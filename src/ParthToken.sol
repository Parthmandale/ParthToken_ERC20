// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity 0.8.20;

// totalSupply()
// balanceOf(account)
// transfer(recipient, amount)
// allowance(owner, spender)
// approve(spender, amount)
// transferFrom(sender, recipient, amount)
// Transfer(from, to, value)
// Approval(owner, spender, value)

contract ParthToken {
    string public s_name;
    string public s_symbol;
    uint256 public i_decimal;
    uint256 public i_totalSupply;
    address public i_owner;

    //  mapping(address => uint) public s_addressToBalance;
    mapping(address => uint) public s_addressToBalance;
    mapping(address => mapping(address => uint)) public s_approvalAmount;

    event Transfer(
        address indexed from,
        address indexed to,
        uint indexed amount
    );
    event Approval(
        address indexed owner,
        address indexed spender,
        uint indexed amount
    );

    constructor() {
        s_name = "ParthToken";
        s_symbol = "PMT";
        i_decimal = 18;
        i_totalSupply = 1000000;
        i_owner = msg.sender;
        s_addressToBalance[msg.sender] = i_totalSupply;
    }

    function totalSupply() public view returns (uint) {
        return i_totalSupply;
    }

    function balanceOf(address owner) public view returns (uint) {
        return s_addressToBalance[owner];
    }

    function transfer(address recipient, uint amount) public {
        require(s_addressToBalance[msg.sender] >= amount, "Not enough fund");
        require(amount > 0, "amount should be greater than 0");

        s_addressToBalance[msg.sender] -= amount;
        s_addressToBalance[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
    }

    function approve(address spender, uint amount) public {
        require(s_addressToBalance[msg.sender] >= 0, "not enough funds");
        require(amount > 0, "amount needed greater than 0");

        s_approvalAmount[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
    }

    function allowance(
        address owner,
        address spender
    ) public view returns (uint) {
        return s_approvalAmount[owner][spender];
    }

    function transferFrom(address owner, address spender, uint amount) public {
        require(
            s_approvalAmount[owner][spender] >= amount,
            "not enough balnce in approval"
        );
        require(
            s_addressToBalance[owner] >= amount,
            "not enough balance in owner account"
        );

        s_approvalAmount[owner][spender] -= amount;
        s_addressToBalance[owner] -= amount;
        s_addressToBalance[spender] += amount;
    }

    // basic req done
}
