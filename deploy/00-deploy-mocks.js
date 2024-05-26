const { network } = require("hardhat")
const { developmentChain } = require("../helper-hardhat-config")
module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log } = deployments
  const { deployer } = await getNamedAccounts()
  if (developmentChain.includes(network.name)) {
    log("Local network detected...Deploying mocks")
    await deploy("MockV3Aggregator", {
      from: deployer,
      args: [8, 200000000000],
      log: true,
    })
    log("Mock deployed!")
    log("------------------------")
  }
}

module.exports.tags = ["all", "mocks"]
