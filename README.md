# 🪙 Decentralized Stablecoin (DSC) — Foundry Project

A decentralized, crypto-collateralized stablecoin built with Solidity and Foundry, featuring algorithmic stability mechanisms and extensive test coverage.

---

## 📖 Overview

This project implements a **Decentralized Stablecoin System** inspired by *Patrick Collins’ Foundry DeFi course*, with extensions and additional test coverage written independently.

It simulates a **crypto-collateralized, algorithmically pegged USD stablecoin**, using ETH and BTC as collateral assets and a **mock price feed system** to simulate market data.

The project includes:

- 🧠 **DSCEngine** — core logic for minting, burning, and collateral management  
- 💰 **DecentralizedStableCoin** — the ERC20 stablecoin token  
- 🧪 **Extensive mock contracts** for testing various edge cases  
- ⚙️ **Automated tests** achieving 91%+ coverage  

---

## 🧩 Key Features

- **Decentralized & Algorithmic:** No central authority — minting and burning are governed by collateral ratios.  
- **Crypto-Collateralized:** Supports multiple collateral types via Chainlink-style oracles.  
- **High Test Coverage:** 91%+ lines, 94%+ functions tested.  
- **Mock Testing Suite:** Covers transfer failures, oracle failures, and over-debt scenarios.  
- **Invariant Testing:** Ensures the protocol always holds more value than total supply.  

---

## 🧱 Smart Contracts

| Contract | Description |
|-----------|-------------|
| `DSCEngine.sol` | Core logic controlling collateral, minting, and burning. |
| `DecentralizedStableCoin.sol` | ERC20 stablecoin representing the system’s token. |
| `MockV3Aggregator.sol` | Simulates Chainlink’s price feed for testing. |
| `MockMoreDebtDSC.sol` | Simulates price collapse and over-debt behavior. |
| `MockFailedMintDSC.sol` | Reverts on mint to test DSCEngine’s resilience. |
| `MockFailedTransfer.sol / From.sol` | Tests transfer-related reverts. |
| `ERC20Mocks.sol` | Basic ERC20 mock for collateral simulation. |

---

## 🧪 Test Coverage

### Total Coverage Summary

Lines: 91.28%

Statements: 91.70%

Branches: 55.56%

Functions: 94.12%


All **unit and invariant tests** were written using **Foundry (Forge)**.

---

## 🧰 Tech Stack

- **Solidity (v0.8.19)**  
- **Foundry / Forge**  
- **Chainlink Mock Oracles**  
- **OpenZeppelin ERC20 & Ownable**  
- **Fuzz & Invariant Testing**

---

## 🚀 How to Run

### 1️⃣ Install Dependencies
```bash
forge install
```

### 🏗️ Build
```bash
forge build
```

### 🧪 Run Tests
```bash
forge test
```

### 📈 Run Coverage
```bash
forge coverage
```

---

## 🧠 Learnings & Challenges

- Implementing a full mock-based test environment beyond the course material

- Handling ownership restrictions, mint/burn reverts, and oracle manipulations

- Understanding the link between collateral ratios and stablecoin supply stability

---

## 🙏 Acknowledgments

Patrick Collins — for the incredible Foundry DeFi Stablecoin course that inspired this build.

ChatGPT (GPT-5) — for reasoning through code, debugging errors, and extending test logic.

---

## 📂 Repository Stats

| Category | Value |
|-----------|-------------|
| 📊 Test Suites | 3 |
| 🧪 Total Tests| 75 |
| ✅ Passed| 75/75 |
| ⚙️ Coverage | 91%+ |
| 🧩 Solidity Version | ^0.8.18 |

---

## 👨‍💻 Author

Built with ❤️ by Ebenezer Evero Ighozino

LinkedIn @https://www.linkedin.com/in/ebenezer-evero-49323b27a/

💬 Twitter/X @https://x.com/BennyEvero

📧 Email @everobennny1627@gmail.com