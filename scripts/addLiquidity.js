// scripts/addLiquidity.js
const { ethers } = require("hardhat");

async function main() {
  const [signer] = await ethers.getSigners();

  const simpleSwapAddress = "0x4AB791880D51CD6A8db850fB14EbB736eCaC12a6"; // nuevo contrato
  const tokenAAddress = "0x035d020fFe37b89fB88A9d3eC0bDBc028Dff7848"; // nuevo tokenA
  const tokenBAddress = "0x77AacFD77b43D11313F0ac31A5f6e340aEd16326"; // nuevo tokenB

  const tokenA = await ethers.getContractAt("IERC20", tokenAAddress);
  const tokenB = await ethers.getContractAt("IERC20", tokenBAddress);
  const simpleSwap = await ethers.getContractAt("SimpleSwap", simpleSwapAddress);

  const amountADesired = ethers.parseUnits("100", 18);
  const amountBDesired = ethers.parseUnits("200", 18);
  const amountAMin = ethers.parseUnits("90", 18);
  const amountBMin = ethers.parseUnits("180", 18);
  const deadline = Math.floor(Date.now() / 1000) + 600;

  // Aprobaciones
  console.log("Aprobando tokens...");
  await tokenA.approve(simpleSwapAddress, amountADesired);
  await tokenB.approve(simpleSwapAddress, amountBDesired);

  // Agregar liquidez
  const tx = await simpleSwap.addLiquidity(
    amountADesired,
    amountBDesired,
    amountAMin,
    amountBMin,
    signer.address,
    deadline
  );

  console.log("Agregando liquidez...");
  await tx.wait();
  console.log("✅ Liquidez agregada con éxito.");
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
