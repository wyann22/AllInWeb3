require("@nomicfoundation/hardhat-verify")
async function verify(contractAdress, args) {
  console.log("Verifying contract...")
  try {
    await run("verify:verify", {
      address: contractAdress,
      constructorArguments: args,
    })
  } catch (e) {
    if (e.message.toLowerCase().includes("already verified")) {
      console.log("Already verified")
    } else {
      console.log(e)
    }
  }
}

module.exports = {
  verify,
}
