<<<<<<< HEAD
var Splitter = artifacts.require("./Splitter.sol");

module.exports = function(deployer) {
deployer.deploy(Splitter,'0xbffe0076ff13d160134089b172527e61c00a33e0','0x6d7dda0ed5783be27c140aef7c5ff39b23269a50');
=======
var Remittance = artifacts.require("./Remittance.sol");

module.exports = function(deployer) {
  deployer.deploy(Remittance,120);
>>>>>>> 87b4707a16e476095d15616021cceaf8116f9b0c
};
