const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contract with address:", deployer.address);

 const tokenA = "0x2230b55ef3237d5c21909d2f0868e34820e50c14";
const tokenB = "0x68194a729c2450ad26072b3d33ada07b5ba8c940";

  const SimpleSwap = await hre.ethers.getContractFactory("SimpleSwap");
  const simpleSwap = await SimpleSwap.deploy(tokenA, tokenB);

  await simpleSwap.waitForDeployment(); // <- importante

  console.log(`SimpleSwap deployed at: ${simpleSwap.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

