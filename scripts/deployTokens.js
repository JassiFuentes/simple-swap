const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  const TokenA = await hre.ethers.getContractFactory("TokenA");
  const tokenA = await TokenA.deploy();
  await tokenA.waitForDeployment();
  console.log("✅ TokenA deployed at:", tokenA.target);

  const TokenB = await hre.ethers.getContractFactory("TokenB");
  const tokenB = await TokenB.deploy();
  await tokenB.waitForDeployment();
  console.log("✅ TokenB deployed at:", tokenB.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
