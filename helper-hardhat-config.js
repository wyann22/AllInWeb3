const networkConfig = {
  11155111: {
    name: "sepolia",
    ethUsdPriceFeed: "0x694AA1769357215DE4FAC081bf1f309aDC325306",
  },
  137: {
    name: "polyon",
    ethUsdPriceFeed: "716hFAECqotxcXcj8Hs8nr7AG6q9dBw2oX3k3M8V7uGq",
  },
}
const developmentChain = ["hardhat", "localhost"]
module.exports = {
  networkConfig,
  developmentChain,
}
