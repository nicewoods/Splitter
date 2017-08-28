var Splitter = artifacts.require("./Splitter.sol");

contract('Splitter', function(accounts) {

   it("should send coin and split on account1, account2", function() {
  
    var splitter;

    // Get initial balances of first and second account.
    var balance;

    var account0Initial = web3.eth.getBalance(accounts[0]);
    var account1Final;
    var account2Final;
    var account1 = accounts[1];
    var account2 = accounts[2];    
    
    return Splitter.deployed().then(function(instance) {
      splitter = instance;
    }).then(function() {
      return splitter.Split(account1, account2, { value: web3.toWei(1, "ether"), gas:1000000});
    }).then(function() {
      return splitter.balances(account1);
    }).then((balance) => {
      account1Final = balance;
      return splitter.balances(account2);
    }).then((balance) => {
      account2Final = balance;
    }).then(()=> {
      console.log("account0Initial: ", account0Initial.toString());
      console.log("account0Final: ", web3.eth.getBalance(accounts[0]).toString());
      console.log("account1Final: ", account1Final.toString());

      assert(account1Final == web3.toWei(0.5,"ether"), "Amount wasn't correctly split on account[1]");
      assert(account2Final == web3.toWei(0.5,"ether"), "Amount wasn't correctly split on account[2]");
  });
});



it("should credit account1, account2", function() {
    var splitter;

    // Get initial balances of first and second account.
    var account1Initial = web3.eth.getBalance(accounts[1]);
    var account2Initial = web3.eth.getBalance(accounts[2]);
    var account1Final;
    var account2Final;
    var account1 = accounts[1];
    var account2 = accounts[2];    

    return Splitter.deployed().then(function(instance) {
      splitter = instance;
      return splitter.SendFunds(accounts[1]);
    }).then(function(h) {
      console.log(h);
      return splitter.SendFunds(accounts[2]);
    }).then((h)=> {
      account1Final = web3.eth.getBalance(accounts[1]);
      account2Final = web3.eth.getBalance(accounts[2]);
    }).then(function (){

      console.log("account1Initial: ", account1Initial.toString());
      console.log("account1Final: ", account1Final.toString());
      console.log("account2Initial: ", account2Initial.toString());
      console.log("account2Final: ", account2Final.toString());
            
      assert(account1Final == account1Initial + web3.toWei(0.5, 'ether'), "Amount1 wasn't correctly taken from the sender");
      assert(account2Final == account2Initial + web3.toWei(0.5, 'ether'), "Amount2 wasn't correctly taken from the sender");
    });

  });
});

