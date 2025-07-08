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
git clone https://github.com/Jassifuentes/simple-swap.git
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

## ✅ Contratos Desplegados

- **SimpleSwap**:  
  [`0x4AB791880D51CD6A8db850fB14EbB736eCaC12a6`](https://sepolia.etherscan.io/address/0x4AB791880D51CD6A8db850fB14EbB736eCaC12a6#code) (Verificado)

- **Token A (ERC20 personalizado)**:  
  [`0x035d020fFe37b89fB88A9d3eC0bDBc028Dff7848`](https://sepolia.etherscan.io/address/0x035d020fFe37b89fB88A9d3eC0bDBc028Dff7848)

- **Token B (ERC20 personalizado)**:  
  [`0x77AacFD77b43D11313F0ac31A5f6e340aEd16326`](https://sepolia.etherscan.io/address/0x77AacFD77b43D11313F0ac31A5f6e340aEd16326)

---

## ⚙️ Scripts disponibles

Todos los scripts están en la carpeta `/scripts` y se ejecutan con:

```bash
npx hardhat run scripts/<nombre_del_script>.js --network sepolia
```

### 📌 Principales scripts

| Script                 | Descripción |
|------------------------|-------------|
| `deploy.js`            | Despliega el contrato SimpleSwap |
| `approveToken.js`      | Aprueba tokens A y B para el contrato |
| `addLiquidity.js`      | Agrega liquidez al pool |
| `checkBalances.js`     | Muestra balances de tokens A, B y SLP del usuario |
| `checkReserves.js`     | Muestra balances dentro del contrato SimpleSwap |
| `getPrice.js`          | Consulta el precio entre los tokens |
| `deployVerifier.js`    | Despliega el contrato verificador personalizado |
| `callVerifier.js`      | Ejecuta la verificación del contrato oficial |

---

## 📩 Ejecución del contrato verificador

✅ Se ejecutó el contrato verificador oficial  
[`0x9f8f02dab384dddf1591c3366069da3fb0018220`](https://sepolia.etherscan.io/address/0x9f8f02dab384dddf1591c3366069da3fb0018220#code)  
con los datos correctos y **se recibió confirmación exitosa** de la transacción:

```
📨 Transacción enviada: 0x7c7185a7fab5b69f197322a6b3df5952acf8bb74203de6db435d3ebcd83eca42
✅ Verificación exitosa
```

## ✍️ Autor

- Nombre: **Jassira Ramos**
- Fecha de entrega: 08/07/2025