const { network } = require("hardhat")
const { networkConfig, developmentChain } = require("../helper-hardhat-config")
const { verify } = require("../utils/verify")
module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy, log, get } = deployments
  const { deployer } = await getNamedAccounts()
  const chainId = network.config.chainId
  let price_contract_address
  if (developmentChain.includes(network.name)) {
    const MockV3AggregatorContract = await get("MockV3Aggregator")
    price_contract_address = MockV3AggregatorContract.address
  } else {
    price_contract_address = networkConfig[chainId]["ethUsdPriceFeed"]
  }
  const args = [price_contract_address]
  const fundMe = await deploy("FundMe", {
    from: deployer,
    args: args,
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  })
  if (
    !developmentChain.includes(network.name) &&
    process.env.ETHERSCAN_API_KEY
  ) {
    log("Verifying contract....")
    await verify(fundMe.address, args)
  }
  log("--------------------------------------")
}
module.exports.tags = ["all", "fundme"]
