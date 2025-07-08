const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying Verifier contract with address:", deployer.address);

  const Verifier = await ethers.getContractFactory("Verifier");
  const verifier = await Verifier.deploy();

  await verifier.waitForDeployment();
  console.log("✅ Verifier deployed at:", verifier.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
