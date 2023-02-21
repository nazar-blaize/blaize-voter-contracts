const BlaizeVoting = artifacts.require('BlaizeVoting')
const BlaizePassport = artifacts.require('BlaizePassport')



module.exports = function(_deployer) {
  _deployer.deploy(BlaizeVoting)
  _deployer.deploy(BlaizePassport)
};
