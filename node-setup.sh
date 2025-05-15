#!/bin/bash

# ChainOS Node Setup Script
# Copyright (c) 2025 Open Crypto Foundation
# This script helps set up a ChainOS node with proper configuration

set -e

# Configuration variables
CHAIN_ID="chainos-1"
MONIKER="my-chainos-node"
GENESIS_URL="https://chainos.network/genesis.json"
SEEDS="2b89c755963a03a2a2c846d5efb97c06e6d2cdfe@chainos.network:26656"
BINARY_NAME="chainosd"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Print banner
echo -e "${GREEN}"
echo "   ______  __    __       ___       __  .__   __.   ______        _______.  "
echo "  /      ||  |  |  |     /   \     |  | |  \ |  |  /  __  \      /       | "
echo " |  ,----'|  |__|  |    /  ^  \    |  | |   \|  | |  |  |  |    |   (----\`"
echo " |  |     |   __   |   /  /_\  \   |  | |  . \`  | |  |  |  |     \   \    "
echo " |  \`----.|  |  |  |  /  _____  \  |  | |  |\   | |  \`--'  | .----)   |   "
echo "  \______||__|  |__| /__/     \__\ |__| |__| \__|  \______/  |_______/    "
echo -e "${NC}"
echo -e "${YELLOW}ChainOS Node Setup - v1.5.05${NC}"
echo

# Check if chainosd is installed
check_binary() {
    echo "Checking for ChainOS binary..."
    if ! command -v $BINARY_NAME &> /dev/null; then
        echo -e "${RED}Error: $BINARY_NAME not found in PATH${NC}"
        echo "Please make sure you have installed the ChainOS binary."
        echo "You can build it from source or download a pre-compiled binary."
        exit 1
    fi
    echo -e "${GREEN}✓ $BINARY_NAME found${NC}"
}

# Initialize the node
init_node() {
    echo "Initializing ChainOS node..."
    read -p "Enter a moniker for your node [default: $MONIKER]: " input_moniker
    MONIKER=${input_moniker:-$MONIKER}
    
    $BINARY_NAME init "$MONIKER" --chain-id $CHAIN_ID
    echo -e "${GREEN}✓ Node initialized with moniker '$MONIKER'${NC}"
}

# Download genesis file
get_genesis() {
    echo "Downloading genesis file..."
    curl -s $GENESIS_URL > $HOME/.chainosd/config/genesis.json
    echo -e "${GREEN}✓ Genesis file downloaded${NC}"
}

# Configure persistent peers
configure_peers() {
    echo "Configuring persistent peers..."
    # Replace the seeds line in config.toml
    sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" $HOME/.chainosd/config/config.toml
    echo -e "${GREEN}✓ Persistent peers configured${NC}"
}

# Configure pruning (optional)
configure_pruning() {
    echo "Configuring pruning options..."
    read -p "Do you want to enable pruning? [y/N]: " enable_pruning
    if [[ $enable_pruning =~ ^[Yy]$ ]]; then
        sed -i.bak -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.chainosd/config/app.toml
        sed -i.bak -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.chainosd/config/app.toml
        sed -i.bak -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"0\"/" $HOME/.chainosd/config/app.toml
        sed -i.bak -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" $HOME/.chainosd/config/app.toml
        echo -e "${GREEN}✓ Pruning configured${NC}"
    else
        echo "Skipping pruning configuration"
    fi
}

# Create systemd service file
create_service() {
    echo "Creating systemd service file..."
    read -p "Do you want to create a systemd service for ChainOS? [y/N]: " create_systemd
    if [[ $create_systemd =~ ^[Yy]$ ]]; then
        SERVICE_PATH="/etc/systemd/system/chainosd.service"
        
        echo "[Unit]
Description=ChainOS Node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which $BINARY_NAME) start
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_PATH > /dev/null

        sudo systemctl daemon-reload
        echo -e "${GREEN}✓ Systemd service created at $SERVICE_PATH${NC}"
        
        read -p "Do you want to enable and start the service now? [y/N]: " start_service
        if [[ $start_service =~ ^[Yy]$ ]]; then
            sudo systemctl enable chainosd
            sudo systemctl start chainosd
            echo -e "${GREEN}✓ ChainOS service started${NC}"
            echo "You can check the status with: sudo systemctl status chainosd"
            echo "View logs with: sudo journalctl -u chainosd -f"
        else
            echo "You can start the service later with: sudo systemctl start chainosd"
        fi
    else
        echo "Skipping systemd service creation"
        echo "You can start the node manually with: $BINARY_NAME start"
    fi
}

# Main execution
main() {
    echo "Starting ChainOS node setup..."
    check_binary
    init_node
    get_genesis
    configure_peers
    configure_pruning
    create_service
    
    echo
    echo -e "${GREEN}ChainOS node setup complete!${NC}"
    echo
    echo "Next steps:"
    echo "1. Start your node if you haven't enabled the service"
    echo "2. Wait for the node to sync with the network"
    echo "3. Use the ChainOS CLI to interact with your node"
    echo
    echo "For more information, visit: https://docs.chainos.network"
    echo
}

# Execute main function
main
