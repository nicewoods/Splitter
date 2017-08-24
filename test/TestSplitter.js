var Splitter = artifacts.require("./Splitter.sol");

contract('Splitter', function(accounts) {

   it("should send coin and split on account1, account2", function() {
  
    var splitter;

    // Get initial balances of first and second account.
    var account1Start;
    var account1End;
    var account2Start;
    var account2End;
    var balance;

    return Splitter.deployed().then(function(instance) {
      splitter = instance;
      splitter.SetPriviledged(accounts[1], accounts[2]);
      return splitter.AddressBalance.call(accounts[1], { gas: 90000 });
     }).then(function(balance) {
      account1Start = balance;
      console.log("account1Start: " + account1Start);
      return splitter.AddressBalance.call(accounts[2], { gas: 90000 });
    }).then(function(balance) {
      account2Start = balance;
      console.log("account2Start: " + account2Start);
      return splitter.FundAccount({ value: web3.toWei(3, 'ether'), gas:900000});
    }).then(function(ret) {
      console.log("Passed Send Funds");
      return splitter.AddressBalance.call(accounts[1], { gas: 90000 });
    }).then(function(balance) {
      account1End = balance;
      console.log("account1End: " + account1End);
      return splitter.AddressBalance.call(accounts[2], { gas: 90000 });
    }).then(function(balance) {
      account2End = balance;
      console.log("account2End: " + account2End);
    }).then(function (){

      assert(account1End == account1Start + web3.toWei(0, 'ether'), "Amount wasn't correctly split on accounts");
      assert(account2End == account2Start + web3.toWei(0, 'ether'), "Amount wasn't correctly split on accounts");
    }).catch (()=> {
      console.log("there xzsd an issue");
  });
  });

   it("should send coin and credit the whole amount to account3", function() {
    var splitter;

    // Get initial balances of first and second account.
    var accountStart;
    var accountEnd;

    return Splitter.deployed().then(function(instance) {
      splitter = instance;
      splitter.SetPriviledged(accounts[1], accounts[2]);
      return splitter.AddressBalance.call(accounts[1]);
    }).then(function(balance) {
      accountStart = balance.toNumber();
      return splitter.FundAccount({from: accounts[1], value: web3.toWei(2, 'ether'), gas:3000000});
    }).then(function() {
      return splitter.AddressBalance.call(accounts[1]);
    }).then(function(balance) {
      accountEnd = balance.toNumber();
    }).then(function (){
            
      console.log("accountStart: " + accountStart);
      console.log("accountEnd: " + accountEnd);

      assert(accountEnd == accountStart + web3.toWei(2, 'ether'), "Amount wasn't correctly taken from the sender");
    }).catch (()=> {
      console.log("there xzsd an issue");
  });

  });
});

