const mytoken = artifacts.require("Halborn");

module.exports = function (deployer) {
  deployer.deploy(mytoken);
};
