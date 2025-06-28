# SimpleSwap - Final Project (Ethereum Developer Bootcamp - Module 3)

## 🎯 Objective

Create a smart contract called `SimpleSwap` that replicates basic Uniswap functionality to:

- Add liquidity
- Remove liquidity
- Swap tokens
- Get token prices
- Calculate expected token output

The goal is to simulate a decentralized exchange without relying on the Uniswap protocol.

---

## ✅ Deployment Details

- ✅ **Contract deployed at:** [0x6DE417A3BEC8dcb251Ecc7342af289Cc34940985](https://sepolia.etherscan.io/address/0x6DE417A3BEC8dcb251Ecc7342af289Cc34940985#code)
- ✅ **Network:** Sepolia Testnet
- ✅ **Verified on Etherscan:** Yes
- ✅ **Constructor parameters:**
  - `tokenA`: 0x2230b55ef3237d5c21909d2f0868e34820e50c14
  - `tokenB`: 0x68194a729c2450ad26072b3d33ada07b5ba8c940

---

## 🧠 Functionalities

### 1️⃣ Add Liquidity

```solidity
function addLiquidity(
    uint amountADesired,
    uint amountBDesired,
    uint amountAMin,
    uint amountBMin,
    address to,
    uint deadline
) external returns (uint amountA, uint amountB, uint liquidity);
```

- Transfers user tokens to contract
- Calculates correct ratio and mints LP tokens
- Protects against slippage and expired transactions

### 2️⃣ Remove Liquidity

```solidity
function removeLiquidity(
    uint liquidity,
    uint amountAMin,
    uint amountBMin,
    address to,
    uint deadline
) external returns (uint amountA, uint amountB);
```

- Burns user's LP tokens
- Returns proportional token amounts to the user
- Enforces slippage and deadline protection

### 3️⃣ Swap Exact Tokens

```solidity
function swapExactTokensForTokens(
    uint amountIn,
    uint amountOutMin,
    address[] calldata path,
    address to,
    uint deadline
) external returns (uint[] memory amounts);
```

- Supports exact input swaps (tokenA ↔ tokenB)
- Includes 0.3% fee
- Uses reserves to calculate output

### 4️⃣ Get Price

```solidity
function getPrice(address tokenA, address tokenB) external view returns (uint price);
```

- Returns tokenA/tokenB price ratio from current reserves

### 5️⃣ Get Amount Out

```solidity
function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
```

- Returns calculated output based on input amount and reserves

---

## 🔧 Technologies Used

- Solidity ^0.8.24
- Hardhat
- Ethers.js
- OpenZeppelin Contracts (ERC20)

---

## 🧪 Setup and Deployment

### 1. Clone the repository
```bash
git clone https://github.com/tu-usuario/simple-swap.git
cd simple-swap
```

### 2. Install dependencies
```bash
npm install
```

### 3. Configure `.env`
```
PRIVATE_KEY=your_private_key
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/your_project_id
ETHERSCAN_API_KEY=your_etherscan_key
```

### 4. Compile contracts
```bash
npx hardhat compile
```

### 5. Deploy to Sepolia
```bash
npx hardhat run scripts/deploy.js --network sepolia
```

### 6. Verify on Etherscan
```bash
npx hardhat verify --network sepolia 0xYourContractAddress tokenA tokenB
```

---

## 📁 File Structure
```
simple-swap/
├── contracts/
│   └── SimpleSwap.sol
├── scripts/
│   └── deploy.js
├── .env.example
├── hardhat.config.js
├── README.md
```
.env file with:

SEPOLIA_RPC_URL

PRIVATE_KEY

ETHERSCAN_API_KEY
---

## ✅ Comments and Best Practices

- ✅ NatSpec comments in English throughout the contract
- ✅ Clear variable names
- ✅ Followed gas optimization and access restriction patterns
- ✅ Used modular helper functions (`min`, `sqrt`, etc.)

---

## 📌 References

- [Uniswap V2 Router Docs](https://docs.uniswap.org/contracts/v2/reference/smart-contracts/router-02)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Hardhat Documentation](https://hardhat.org)

---

## 💯 Final Notes

The contract was fully implemented, tested, deployed, and verified, following all requirements of the final project. Every function was documented and coded cleanly, with an emphasis on readability, security, and performance.

---
 **link al contrato verificado en Etherscan**
https://sepolia.etherscan.io/address/0x6DE417A3BEC8dcb251Ecc7342af289Cc34940985
**Author:** Jassira Ramos  
**Bootcamp:** Ethereum Developer - Módulo 3

