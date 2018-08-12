var Splitter = artifacts.require("./Splitter.sol");

module.exports = function(deployer) {
  const a1 = "0x056923e4f90eab8b3352a2631df96bf6a7a2f019";
  const a2 = "0x323f656df2ad3c1d9a67e3216da81fe0366bdc2d";
  deployer.deploy(Splitter, a1, a2);
}
