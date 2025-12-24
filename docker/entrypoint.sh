#!/bin/bash

# Start Anvil (the local Ethereum node)
# --host 0.0.0.0 makes it accessible outside the container
anvil --host 0.0.0.0 &

# Wait for Anvil to start up
echo "Waiting for Anvil to start..."
sleep 5

# Deploy the contracts
echo "Deploying contracts..."
# This uses the first default Anvil private key
export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

forge script script/Deploy.s.sol:DeploySystem \
    --rpc-url http://127.0.0.1:8545 \
    --broadcast \
    --verbosity

echo "Deployment complete. System is ready."

# Keep the process running so the container doesn't exit
wait