const { NomicLabsHardhatPluginError } = require("hardhat/plugins")

require("@nomicfoundation/hardhat-toolbox")
require("dotenv").config()
require("./task/block-number")
require("hardhat-gas-reporter")
require("hardhat-deploy")

const SEPOLIA_RPC_URL = process.env.SEPOLIA_PROVIDER_RPC
const ACCOUNT = process.env.PRIVATE_KEY
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY
const CMC_API_KEY = process.env.CMC_API_KEY
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.8",
  defaultNetWork: "hardhat",
  networks: {
    sepolia: {
      url: SEPOLIA_RPC_URL,
      accounts: [ACCOUNT],
      chainId: 11155111,
      blockConfirmations: 6,
    },
    localhost: {
      url: "http://127.0.0.1:8545/",
      chainId: 31337,
      //accounts: hardhat helps
    },
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    user: {
      default: 1,
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
  gasReporter: {
    enabled: true,
    outputFile: "gas-report.txt",
    noColors: "USD",
    coinmarketcap: CMC_API_KEY,
  },
}
