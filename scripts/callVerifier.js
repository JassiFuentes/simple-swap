const { ethers } = require("hardhat");

async function main() {
  const signer = (await ethers.getSigners())[0];

    const verifierAddress = "0x9C982edb7DaFFDA48715E23f426dea88BBE92d84";

  const verifierAbi = [
    "function verify(address swapContract, address tokenA, address tokenB, uint256 amountA, uint256 amountB, uint256 amountIn, string author) external"
  ];

  const verifier = new ethers.Contract(verifierAddress, verifierAbi, signer);

  const swapContract = "0x4AB791880D51CD6A8db850fB14EbB736eCaC12a6"; // contrato
  const tokenA = "0x035d020fFe37b89fB88A9d3eC0bDBc028Dff7848"; // Token A
  const tokenB = "0x77AacFD77b43D11313F0ac31A5f6e340aEd16326"; // Token B
  const amountA = ethers.parseUnits("100", 18);
  const amountB = ethers.parseUnits("200", 18);
  const amountIn = ethers.parseUnits("50", 18); 
  const author = "Jassira Ramos"; 
  const tx = await verifier.verify(swapContract, tokenA, tokenB, amountA, amountB, amountIn, author);
  console.log("📨 Transacción enviada:", tx.hash);
  await tx.wait();
  console.log("✅ Verificación exitosa.");
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});


