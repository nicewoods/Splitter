pragma solidity ^0.4.0;

contract Remittance {
//0x98a85567db3806aefd03ce84271eccfed04bf1323abc6f9ee0e86230ddd543c2
    
    address _owner;
 
    struct Deposit
    {
        uint amount;
        bytes32 secret;
        uint deadline;
    }    

    mapping(address => Deposit) _repository;
    uint    public _limit;
 
    function Remittance(uint durationContract)
    {
        _owner = msg.sender;
        _limit = block.timestamp + durationContract;
    }

    function getCreditAmount(address depositor)  public  returns(uint)
    {
        return _repository[depositor].amount;
    }
    
    function getSecret(address depositor) public returns (bytes32)
    {
        return _repository[depositor].secret;
    }

    event LogNewCredit(address depositor, uint amount);
    event LogRetrievalSucceeded(address beneficiary, uint amount);
    event LogRefund(address beneficiary, uint amount);
    event LogSuicide(address beneficiary, uint amount);

    // owner can add credit to the contract any time
    function addCredit(bytes32 theSecret, uint theDeadline) public payable returns (bool)
    {
        if (theSecret.length == 0 || msg.value == 0)
            throw;

        if (theDeadline == 0)
            throw;

        if (block.timestamp > _limit)
            throw;

        Deposit storage theDeposit = _repository[msg.sender];

        theDeposit.secret = theSecret;
        theDeposit.amount = msg.value;
        theDeposit.deadline = theDeadline + block.number;
        
        LogNewCredit(msg.sender, msg.value);
        return true; // owner will maintain a list of depositors outside the contract
    }

    
    function retrieveAmount(string password1, string password2, address depositor) public returns (bool)
    {
        if (block.timestamp > _limit)
            throw;

        Deposit storage theDeposit = _repository[depositor];
        
        if (theDeposit.amount == 0 || theDeposit.deadline < block.number)
            throw;
        
        var proof = keccak256(password1, password2);
        
        if (proof != theDeposit.secret)
            throw;
    
        if (! msg.sender.send(theDeposit.amount))
            throw;
        
        theDeposit.amount = 0;
        theDeposit.secret = 0;
        
        LogRetrievalSucceeded(msg.sender,  theDeposit.amount);            
        return true;
    }
    
    function Refund(address depositor) public returns(bool)
    {
        Deposit storage theDeposit = _repository[depositor];

        if (theDeposit.amount == 0)
            throw;

        if (! depositor.send(theDeposit.amount)) 
            throw;

        LogRefund(depositor, theDeposit.amount);
    }

    function suicide() public returns (bool)
    {
        selfdestruct(_owner); // in case there is a self destroy owner will receive the ether and dispatch to despositors
    }    
}
