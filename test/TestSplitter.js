var Splitter = artifacts.require("./Splitter.sol");

contract('Splitter', function(accounts) {
   it("should send coin correctly", function() {
    var meta;

    // Get initial balances of first and second account.
    var account_one = accounts[0];
    var account_two = accounts[1];

    var account_one_starting_balance;
    var account_two_starting_balance;
    var account_one_ending_balance;
    var account_two_ending_balance;

    var amount = 10;

    return Splitter.deployed().then(function(instance) {
      meta = instance;
      return meta.AddressBalance.call(account_one);
    }).then(function(balance) {
      account_one_starting_balance = balance.toNumber();
      return meta.AddressBalance.call(account_two);
    }).then(function(balance) {
      account_two_starting_balance = balance.toNumber();
      return meta.FundAccount({value: web3.toWei(2, 'ether')});
    }).then(function() {
      return meta.AddressBalance.call(account_one);
    }).then(function(balance) {
      account_one_ending_balance = balance.toNumber();
      return meta.AddressBalance.call(account_two);
    }).then(function(balance) {
      account_two_ending_balance = balance.toNumber();
    }).then(function (){
      console.log(account_one_starting_balance);
      console.log(account_one_ending_balance);
      console.log(account_two_starting_balance);
      console.log(account_two_ending_balance);
      assert(account_one_ending_balance == account_one_starting_balance + web3.toWei(1, 'ether'), "Amount wasn't correctly taken from the sender");
      assert(account_two_ending_balance == account_two_starting_balance + web3.toWei(1, 'ether'), "Amount wasn't correctly sent to the receiver");
    });

    });
  });

