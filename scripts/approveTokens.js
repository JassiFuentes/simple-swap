// scripts/approveToken.js
const { ethers } = require("hardhat");

async function main() {
  const [signer] = await ethers.getSigners();

  const simpleSwapAddress = "0x4AB791880D51CD6A8db850fB14EbB736eCaC12a6";
  const tokenAAddress = "0x035d020fFe37b89fB88A9d3eC0bDBc028Dff7848";
  const tokenBAddress = "0x77AacFD77b43D11313F0ac31A5f6e340aEd16326";

  // Cantidades diferentes para cada token
  const amountA = ethers.parseUnits("100", 18); // Token A
  const amountB = ethers.parseUnits("200", 18); // Token B

  const tokenA = await ethers.getContractAt("IERC20", tokenAAddress);
  const tokenB = await ethers.getContractAt("IERC20", tokenBAddress);

  console.log("Aprobando Token A...");
  const txA = await tokenA.approve(simpleSwapAddress, amountA);
  await txA.wait();
  console.log("✅ Token A aprobado.");

  console.log("Aprobando Token B...");
  const txB = await tokenB.approve(simpleSwapAddress, amountB);
  await txB.wait();
  console.log("✅ Token B aprobado.");
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});


