const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contract with address:", deployer.address);

 const tokenA = "0x035d020fFe37b89fB88A9d3eC0bDBc028Dff7848";
const tokenB = "0x77AacFD77b43D11313F0ac31A5f6e340aEd16326";

  const SimpleSwap = await hre.ethers.getContractFactory("SimpleSwap");
  const simpleSwap = await SimpleSwap.deploy(tokenA, tokenB);

  await simpleSwap.waitForDeployment(); // <- importante

  console.log(`SimpleSwap deployed at: ${simpleSwap.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

