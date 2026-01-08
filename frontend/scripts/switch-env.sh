#!/bin/bash
# Environment switching script for Vault frontend
# Usage: ./scripts/switch-env.sh {local|sepolia|mainnet}

set -e

echo "🔧 Vault Frontend Environment Switcher"
echo "=========================================="

# Check if correct argument provided
if [ $# -eq 0 ]; then
    echo "❌ Error: No environment specified"
    echo ""
    echo "Usage: $0 {local|sepolia|mainnet}"
    echo ""
    echo "Available environments:"
    echo "  local     - Local Anvil/Hardhat development"
    echo "  sepolia   - Base Sepolia testnet"
    echo "  mainnet   - Base mainnet"
    exit 1
fi

# Define environment variables
ENVIRONMENT="$1"
ENV_FILE="./.env"

case "$ENVIRONMENT" in
    "local")
        echo "🏠 Switching to LOCAL development environment"
        echo "Using local Anvil/Hardhat blockchain"
        CONTRACT_ADDRESS="0x5FbDB2315678afecb367f032d93F642f64180aa3"  # Default Anvil address
        echo ""
        echo "📋 Environment Setup:"
        echo "  Network: Local (Anvil/Hardhat)"
        echo "  Contract: $CONTRACT_ADDRESS"
        echo "  RPC: http://localhost:8545"
        ;;
    "sepolia")
        echo "🧪 Switching to BASE SEPOLIA testnet"
        echo "Using Base Sepolia testnet"
        echo ""
        echo "⚠️  IMPORTANT: Replace with your actual testnet contract address"
        CONTRACT_ADDRESS="0x1234567890123456789012345678901234567890"  # Placeholder
        echo ""
        echo "📋 Environment Setup:"
        echo "  Network: Base Sepolia Testnet"
        echo "  Contract: $CONTRACT_ADDRESS (PLACEHOLDER - UPDATE ME)"
        echo "  RPC: https://sepolia.base.org"
        echo ""
        echo "📌 To deploy your own testnet contract:"
        echo "   1. Run: forge create Vault --rpc-url \$RPC_URL --private-key \$PRIVATE_KEY --constructor-args 3600"
        echo "   2. Update CONTRACT_ADDRESS with your deployed address"
        ;;
    "mainnet")
        echo "🚀 Switching to BASE MAINNET"
        echo "Using Base mainnet"
        echo ""
        echo "⚠️  WARNING: This is PRODUCTION environment!"
        echo "⚠️  IMPORTANT: Replace with your actual mainnet contract address"
        CONTRACT_ADDRESS="0xabcdefabcdefabcdefabcdefabcdefabcdefabcd"  # Placeholder
        echo ""
        echo "📋 Environment Setup:"
        echo "  Network: Base Mainnet (PRODUCTION)"
        echo "  Contract: $CONTRACT_ADDRESS (PLACEHOLDER - UPDATE ME)"
        echo "  RPC: https://mainnet.base.org"
        echo ""
        echo "📌 To deploy your own mainnet contract:"
        echo "   1. Run: forge create Vault --rpc-url \$RPC_URL --private-key \$PRIVATE_KEY --constructor-args 31536000"
        echo "   2. Update CONTRACT_ADDRESS with your deployed address"
        ;;
    *)
        echo "❌ Error: Unknown environment '$ENVIRONMENT'"
        echo ""
        echo "Usage: $0 {local|sepolia|mainnet}"
        exit 1
        ;;
esac

# Check if .env.example exists
if [ ! -f ".env.example" ]; then
    echo "❌ Error: .env.example not found"
    echo "Make sure you're running this script from the frontend directory"
    exit 1
fi

# Copy .env.example to .env if .env doesn't exist
if [ ! -f ".env" ]; then
    echo "📝 Creating .env from .env.example..."
    cp .env.example .env
fi

# Update VITE_VAULT_ADDRESS in .env
echo "🔄 Updating VITE_VAULT_ADDRESS in .env..."

# Use different methods for different operating systems
if command -v gsed >/dev/null 2>&1; then
    # macOS with gsed installed
    gsed -i.bak "s|^VITE_VAULT_ADDRESS=.*|VITE_VAULT_ADDRESS=$CONTRACT_ADDRESS|" .env
    rm .env.bak 2>/dev/null || true
elif command -v sed >/dev/null 2>&1; then
    # Linux/Unix with sed
    sed -i.bak "s|^VITE_VAULT_ADDRESS=.*|VITE_VAULT_ADDRESS=$CONTRACT_ADDRESS|" .env
    rm .env.bak 2>/dev/null || true
else
    # Fallback - manual replacement
    echo ""
    echo "⚠️  Cannot automatically update .env file (sed not available)"
    echo "📝 Please manually update VITE_VAULT_ADDRESS in your .env file:"
    echo "   Current: VITE_VAULT_ADDRESS=your_deployed_vault_contract_address_here"
    echo "   Replace with: VITE_VAULT_ADDRESS=$CONTRACT_ADDRESS"
    echo ""
fi

# Verify the update
if command -v grep >/dev/null 2>&1; then
    echo ""
    echo "✅ Environment configuration updated:"
    echo "   VITE_VAULT_ADDRESS=$CONTRACT_ADDRESS"
    echo ""
    echo "📄 Current .env configuration:"
    grep -E "^VITE_(REOWN_PROJECT_ID|VAULT_ADDRESS)" .env 2>/dev/null || echo "   (Check .env file manually)"
fi

echo ""
echo "🎯 Next Steps:"
case "$ENVIRONMENT" in
    "local")
        echo "1. Start local blockchain: anvil"
        echo "2. Deploy contract if needed: forge create Vault --rpc-url http://localhost:8545 --constructor-args 3600"
        echo "3. Start frontend: npm run dev"
        echo "4. Connect MetaMask to localhost network"
        ;;
    "sepolia")
        echo "1. Deploy to testnet if needed"
        echo "2. Update .env with your actual testnet contract address"
        echo "3. Start frontend: npm run dev"
        echo "4. Connect MetaMask to Base Sepolia network"
        echo "5. Get testnet ETH from faucet"
        ;;
    "mainnet")
        echo "1. Deploy to mainnet if needed"
        echo "2. Update .env with your actual mainnet contract address"
        echo "3. Start frontend: npm run dev"
        echo "4. Connect MetaMask to Base network"
        echo "5. Use with real ETH"
        ;;
esac

echo ""
echo "📚 For detailed setup instructions, see:"
echo "   - CONTRACTS.md#-local-development-setup"
echo "   - frontend/README.md"
echo ""
echo "🚀 Ready to start development with $ENVIRONMENT environment!"
echo ""

# Offer to start development server
read -p "🤔 Would you like to start the development server now? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Starting development server..."
    echo "   Frontend will be available at: http://localhost:3000"
    echo "   Press Ctrl+C to stop the server"
    echo ""
    npm run dev
else
    echo "👍 Environment setup complete! Run 'npm run dev' when ready to start the frontend."
fi