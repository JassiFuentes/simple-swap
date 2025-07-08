const { ethers } = require("hardhat");

async function main() {
  const [signer] = await ethers.getSigners();

  const tokenA = await ethers.getContractAt("IERC20", "0x035d020fFe37b89fB88A9d3eC0bDBc028Dff7848");
  const tokenB = await ethers.getContractAt("IERC20", "0x77AacFD77b43D11313F0ac31A5f6e340aEd16326");

  const simpleSwap = await ethers.getContractAt("SimpleSwap", "0x4AB791880D51CD6A8db850fB14EbB736eCaC12a6");

  const balanceA = await tokenA.balanceOf(signer.address);
  const balanceB = await tokenB.balanceOf(signer.address);
  const lpBalance = await simpleSwap.balanceOf(signer.address);

  console.log("👤 Wallet:", signer.address);
  console.log("🪙 Token A balance:", ethers.formatUnits(balanceA, 18));
  console.log("🪙 Token B balance:", ethers.formatUnits(balanceB, 18));
  console.log("🧾 LP Token (SLP) balance:", ethers.formatUnits(lpBalance, 18));
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});

