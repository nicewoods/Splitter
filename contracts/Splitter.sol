pragma solidity ^0.4.0;

contract Splitter
{
    address owner;
    uint fundsProcessed;    
    
    mapping(address => uint) public balances;
    
   // event LogFund(address, address, address, uint);
   // event LogSendFunds(address, uint);

    function Splitter ()
    {
        owner = msg.sender;
    }

    
    function Split(address receiver1, address receiver2) public payable
    {
        uint credit = msg.value / 2;  // if there is a remainder  ether, it stays on the accounts balance, which we suppose is for the owner

        balances[receiver1] += credit;
        balances[receiver2] += credit;

        fundsProcessed += msg.value;    

        uint remainingAmount = msg.value - 2 * credit;

        if (remainingAmount != 0)
        {
            if (!msg.sender.send(remainingAmount))
                throw;
        }    
     //   LogFund(msg.sender, receiver1, receiver2, msg.value);
    }
    
    function SendFunds(address recipient)
    {
        if (msg.sender != owner)
            throw;

        if (balances[recipient] == 0)
            throw;
        
        balances[recipient] = 0;

        if (!recipient.send(balances[recipient]))
            throw;

      //  LogSendFunds(recipient, balances[recipient]);
    }  
}

