const { ethers, getNamedAccounts } = require("hardhat")
async function main() {
  const { deployer } = await getNamedAccounts()
  const fundMe = await ethers.getContractAt("FundMe", deployer)
  console.log(`Got contract Fundme at ${await fundMe.getAddress()}`)
  console.log("Funding contract...")
  const transactionRes = await fundMe.fund({ value: ethers.parseEther("0.1") })
  await transactionRes.wait(1)
  console.log("Funded!")
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
