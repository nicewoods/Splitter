pragma solidity ^0.4.0;

contract Splitter
{
    address _owner;
    
    mapping(address => uint) public _accounts;
    address[2] _holders;
    uint _totalBalance;
    
    function Splitter (address holder0, address holder1)
    {
        _owner = msg.sender;
        _holders[0] = holder0;
        _holders[1] = holder1;
    }
    
    //event LogFundAccount(address holder, uint bal);
    //event LogTotalBalance(uint);
    
    function FundAccount() public payable returns (bool r)
    {
        if (msg.value == 0.)
            throw;
        
        _totalBalance += msg.value;
        
        if (msg.sender == _owner)
        {
            uint credit0 = msg.value / 2;
            uint credit1 =  msg.value - credit0;

	    address holder0;
            address holder1;

	    holder0 = _holders[0];
            holder1 = _holders[1];
            _accounts[holder0] += credit0;
            _accounts[holder1] += credit1;
            
            if (!holder0.send(credit0))
		throw;
            if (!holder1.send(credit1))
		throw;
            
           LogFundAccount(holder0, _accounts[holder0]);
           LogFundAccount(holder1, _accounts[holder1]);
           LogTotalBalance(_totalBalance);
        }    
    }
    
    function GetTotalBalance() public constant returns (uint)
    {
        return _totalBalance;
    }
    
    
    function AddressBalance(address holder) public constant returns (uint)
    {
        if ( _holders[0] != holder && _holders[1] != holder)
            throw;
        return _accounts[holder];
    }
}

