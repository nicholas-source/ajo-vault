# Ajo Vault Frontend

A modern, decentralized savings application built with **React**, **Vite**, **REOWN AppKit**, and **WalletConnect** on Base blockchain.

## 🚀 Features

- **REOWN AppKit Integration**: Seamless wallet connection with WalletConnect v2
- **Base Network Support**: Built for Base Sepolia testnet and Base mainnet
- **Time-Locked Savings**: Deposit ETH with enforced lock periods
- **Modern UI/UX**: Responsive design with glass-morphism effects
- **Real-time Updates**: Live balance and countdown timer
- **Type-Safe**: Built with TypeScript

## 📋 Prerequisites

- Node.js (v18 or higher)
- npm or yarn
- A REOWN Project ID ([Get one here](https://cloud.reown.com/))
- MetaMask or any WalletConnect-compatible wallet

## 🛠️ Installation

1. **Install dependencies:**
   \`\`\`bash
   npm install
   \`\`\`

2. **Configure environment variables:**
   \`\`\`bash
   cp .env.example .env
   \`\`\`

3. **Edit \`.env\` file:**
   \`\`\`env
   VITE_REOWN_PROJECT_ID=your_reown_project_id_here
   VITE_PIGGYBANK_ADDRESS=deployed_contract_address
   \`\`\`

   **To get a REOWN Project ID:**
   - Visit [REOWN Cloud](https://cloud.reown.com/)
   - Create a new project
   - Copy your Project ID

   **Environment Variable Validation:**
   - `VITE_REOWN_PROJECT_ID`: **Required** - Always causes build error if missing
   - `VITE_PIGGYBANK_ADDRESS`: **Required in CI/Production** - Causes error in CI/production builds, warning in local development
   - Validation runs automatically on application startup
   - Missing required variables will block CI/CD builds to prevent runtime failures

## 🚀 Quick Local Development

For comprehensive local development setup with contracts, see the complete guide in [CONTRACTS.md#local-development-setup](../CONTRACTS.md#-local-development-setup).

**Quick Environment Switching:**
\`\`\`bash
# Switch to local development (uses Anvil default contract)
./scripts/switch-env.sh local

# Switch to testnet (you'll need to deploy your own contract)
./scripts/switch-env.sh sepolia

# Switch to mainnet (production)
./scripts/switch-env.sh mainnet
\`\`\`

**Windows users:**
\`\`\`powershell
.\scripts\switch-env.ps1 -Environment local
\`\`\`

## 🎯 Available Scripts

### Development
\`\`\`bash
npm run dev
\`\`\`
Runs the app in development mode on [http://localhost:3000](http://localhost:3000)

### Build
\`\`\`bash
npm run build
\`\`\`
Builds the app for production to the \`dist\` folder

### Preview
\`\`\`bash
npm run preview
\`\`\`
Preview the production build locally

### Lint
\`\`\`bash
npm run lint
\`\`\`
Check code for linting errors

### Test
\`\`\`bash
npm test
\`\`\`
Run all unit and component tests

\`\`\`bash
npm run test:ui
\`\`\`
Run tests with Vitest UI

\`\`\`bash
npm run test:coverage
\`\`\`
Generate test coverage report

### Environment Management

\`\`\`bash
# Switch to local development environment (Anvil/Hardhat)
./scripts/switch-env.sh local

# Switch to Base Sepolia testnet
./scripts/switch-env.sh sepolia

# Switch to Base mainnet
./scripts/switch-env.sh mainnet
\`\`\`

**Windows PowerShell Users:**
\`\`\`powershell
# Switch to local development environment (Anvil/Hardhat)
.\scripts\switch-env.ps1 -Environment local

# Switch to Base Sepolia testnet
.\scripts\switch-env.ps1 -Environment sepolia

# Switch to Base mainnet
.\scripts\switch-env.ps1 -Environment mainnet
\`\`\`

These scripts automatically update your \`.env\` file with the appropriate contract address for each environment.

## 🏗️ Project Structure

\`\`\`
frontend/
├── src/
│   ├── components/          # React components
│   │   ├── Header.tsx       # App header with wallet connect
│   │   ├── VaultDashboard.tsx
│   │   ├── BalanceCard.tsx  # Balance display with countdown
│   │   ├── DepositForm.tsx  # Deposit ETH form
│   │   ├── WithdrawButton.tsx
│   │   ├── BalanceCard.test.tsx      # BalanceCard tests
│   │   ├── DepositForm.test.tsx      # DepositForm tests
│   │   └── WithdrawButton.test.tsx   # WithdrawButton tests
│   ├── config/              # Configuration files
│   │   ├── wagmi.ts         # REOWN AppKit & Wagmi setup
│   │   └── contracts.ts     # Smart contract ABIs & addresses
│   ├── hooks/               # Custom React hooks
│   │   ├── useVault.ts  # Contract interaction hook
│   │   ├── useTimelock.ts   # Time lock countdown logic
│   │   └── useTimelock.test.ts       # useTimelock tests
│   ├── test/                # Test setup
│   │   └── setup.ts         # Vitest configuration
│   ├── App.tsx              # Main app component
│   ├── main.tsx             # Entry point
│   ├── App.css              # Component styles
│   └── index.css            # Global styles
├── scripts/                 # Helper scripts
│   ├── switch-env.sh        # Environment switching (Unix/Linux/macOS)
│   └── switch-env.ps1       # Environment switching (Windows PowerShell)
├── package.json
├── vite.config.ts
├── tsconfig.json
└── .env.example
\`\`\`

## 🔧 Tech Stack

| Technology | Purpose |
|------------|---------|
| **React 19** | UI library |
| **Vite 7** | Build tool & dev server |
| **TypeScript** | Type safety |
| **REOWN AppKit** | Wallet connection & WalletConnect integration |
| **Wagmi** | Ethereum interactions |
| **Viem** | Lightweight Ethereum library |
| **TanStack Query** | Async state management |
| **Base Network** | Layer 2 blockchain |
| **Vitest** | Testing framework |
| **React Testing Library** | Component testing utilities |

## 🧪 Testing

This project includes comprehensive test coverage for all lock/unlock and countdown functionality.

### Test Coverage
- **useTimelock Hook** (23 tests): Time calculations, state transitions, edge cases
- **BalanceCard Component** (15 tests): Lock/unlock states, countdown rendering
- **WithdrawButton Component** (20 tests): Button states, balance validation
- **DepositForm Component** (27 tests): Form validation, lock info formatting
- **TransactionToast Component**: Transaction feedback consistency tests

### Transaction Feedback Consistency

The **TransactionToast** component ensures consistent user feedback for all transaction states:

| State | Toast Message | Behavior |
|-------|---------------|----------|
| **Pending** | "Transaction submitted" | Always shown when transaction is sent |
| **Success** | "Transaction confirmed" | Always shown when transaction succeeds |
| **Error** | "Transaction failed" | Always shown when transaction fails |

This guarantees users always receive clear, unambiguous feedback about their transaction status, eliminating the inconsistency mentioned in issue #26.

All transaction states include:
- Clear status message
- Transaction explorer link (when available)
- Appropriate visual indicators (⏳/✅/❌)
- Auto-dismissal after appropriate delays

### Running Tests
\`\`\`bash
# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch

# Run tests with UI
npm run test:ui

# Generate coverage report
npm run test:coverage
\`\`\`

All tests validate:
- ✅ Time calculations (days, hours, minutes, seconds)
- ✅ Countdown updates and transitions
- ✅ Lock/unlock state rendering
- ✅ Edge cases (past times, exact boundaries, large values)
- ✅ Time travel scenarios with fake timers

## 🌐 REOWN & WalletConnect Integration

This project uses **REOWN AppKit** (formerly WalletConnect AppKit) for all wallet interactions.

**Built with ❤️ using REOWN AppKit & WalletConnect on Base**
