pragma solidity ^0.4.0;

contract Splitter
{
    address _owner;
    
    mapping(address => uint) public _accounts;
    
    address[2] _priviledged; // those will receive part of credit sent by the ower
    uint _totalBalance;
    uint _distributedToAccounts;

    function Splitter ()
    {
        _owner = msg.sender;
    }
    
    function SetPriviledged(address holder0, address holder1) public 
    {
        _priviledged[0] = holder0; // account holders 
        _priviledged[1] = holder1;
    }

    event LogFundAccount(address holder, uint bal);
    event LogTotalBalance(uint);
    
    function FundAccount() public payable returns (bool r)
    {
        if (msg.value == 0)
            throw;

        if ((msg.sender != _owner) && (msg.sender != _priviledged[0]) && (msg.sender != _priviledged[1]))
            throw;
        
        _totalBalance += msg.value;
        
        if (msg.sender == _owner) 
        {
            uint credit = msg.value / 2;  // if there is a remainder  ether, it stays on the accounts balance, which we suppose is for the owner

            address holder0 = _priviledged[0];
            address holder1 = _priviledged[1];

            _accounts[holder0] += credit;
            _accounts[holder1] += credit;

            _distributedToAccounts += 2 * credit;    

            //LogFundAccount(holder0, credit);
            //LogFundAccount(holder1, credit);
        }
        else
        {
            _accounts[msg.sender] += msg.value;
            _distributedToAccounts += msg.value;

            //LogFundAccount(msg.sender, msg.value);
        }

        //LogTotalBalance(_totalBalance);
        return true;
    }
    
    function GetTotalBalance() public constant returns (uint)
    {
        return _totalBalance;
    }
    
    
    function AddressBalance(address holder) public returns (uint) 
    {
        uint val;

        if (holder != _owner)
            val = _accounts[holder];
        else
            val = _totalBalance - _distributedToAccounts;
        return val;
    }

// another function needed to send funds
}

