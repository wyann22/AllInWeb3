const { ethers, getNamedAccounts, network } = require("hardhat")
async function main() {
  const { deployer } = await getNamedAccounts()
  const fundMe = await ethers.getContractAt("FundMe", deployer)
  console.log(`Got contract Fundme at ${await fundMe.getAddress()}`)
  console.log("Calling Withdraw")
  const transactionRes = await fundMe.withdraw()
  await transactionRes.wait(1)

  console.log(` Withdrawed!`)
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
