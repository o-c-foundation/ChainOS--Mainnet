#!/bin/bash

# ChainOS CLI - An interactive wrapper for chainosd
# Copyright (c) 2025 Open Crypto Foundation
# Date: 2025-05-15

# Find chainosd binary in PATH or use the local one
if command -v chainosd &> /dev/null; then
    CHAINOSD="chainosd"
else
    CHAINOSD="./cmd/chainosd/chainosd"
fi

NODE="tcp://chainos.network:26657"
CHAIN_ID="chainos-1"
FEE_DENOM="chaincoin"
HOME_DIR="$HOME/.chainosd"
KEYRING_BACKEND="test"  # Use 'test' for development, 'file' for production

# Different flags for different command types
KEY_FLAGS="--home=$HOME_DIR --keyring-backend=$KEYRING_BACKEND"
TX_FLAGS="--node=$NODE --chain-id=$CHAIN_ID --home=$HOME_DIR --keyring-backend=$KEYRING_BACKEND"
QUERY_FLAGS="--node=$NODE --chain-id=$CHAIN_ID --home=$HOME_DIR"

# Text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Display ASCII art banner
display_banner() {
  clear
  echo -e "${CYAN}"
  cat << "EOF"
   ______  __    __       ___       __  .__   __.   ______        _______.  
  /      ||  |  |  |     /   \     |  | |  \ |  |  /  __  \      /       | 
 |  ,----'|  |__|  |    /  ^  \    |  | |   \|  | |  |  |  |    |   (----`
 |  |     |   __   |   /  /_\  \   |  | |  . `  | |  |  |  |     \   \    
 |  `----.|  |  |  |  /  _____  \  |  | |  |\   | |  `--'  | .----)   |   
  \______||__|  |__| /__/     \__\ |__| |__| \__|  \______/  |_______/    
EOF
  echo -e "${GREEN}"
  echo "╔════════════════════════════════════════════════════════════════════╗"
  echo "║                       ChainOS Interactive CLI                      ║"
  echo "║                Manage your ChainOS blockchain easily               ║"
  echo "╚════════════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"
}

# Display beginning banner
display_banner

# Ensure chainosd is available
if [ ! -f "$CHAINOSD" ]; then
    echo -e "${RED}Error: chainosd binary not found at $CHAINOSD${NC}"
    exit 1
fi

# Interactive mode flag
INTERACTIVE=false
if [ "$1" == "--interactive" ] || [ "$1" == "-i" ] || [ "$#" -eq 0 ]; then
    INTERACTIVE=true
fi

# Interactive menu function
interactive_menu() {
    local title=$1
    shift
    declare -a options
    
    # Store each argument as a separate menu option
    local i=0
    while [ $# -gt 0 ]; do
        options[i]="$1"
        ((i++))
        shift
    done
    
    local selected=0
    local key=""
    
    while true; do
        clear
        display_banner
        echo -e "${YELLOW}$title${NC}"
        echo
        
        # Display each menu option on its own line
        for i in ${!options[@]}; do
            if [ $i -eq $selected ]; then
                echo -e "${GREEN}> ${options[$i]}${NC}"
            else
                echo "  ${options[$i]}"
            fi
        done
        
        echo -e "\n${BLUE}Use arrow keys to navigate and Enter to select. Q to quit.${NC}"
        
        # Read a single key press
        read -s -n 1 key
        
        case $key in
            "A") # Up arrow
                if [ $selected -gt 0 ]; then
                    selected=$((selected-1))
                fi
                ;;
            "B") # Down arrow
                if [ $selected -lt $((${#options[@]}-1)) ]; then
                    selected=$((selected+1))
                fi
                ;;
            "") # Enter key
                echo
                return $selected
                ;;
            "q"|"Q") # Quit
                echo
                exit 0
                ;;
        esac
    done
}

# Input text with prompt
get_input() {
    local prompt=$1
    local default_value=$2
    local result
    
    if [ -z "$default_value" ]; then
        read -p "${YELLOW}$prompt: ${NC}" result
    else
        read -p "${YELLOW}$prompt [${default_value}]: ${NC}" result
        result=${result:-$default_value}
    fi
    
    echo $result
}

# Function to display usage information
function show_usage {
    echo -e "${YELLOW}Usage:${NC} $0 [command] [options]"
    echo 
    echo -e "${YELLOW}Available Commands:${NC}"
    echo -e "  ${GREEN}wallet${NC}"
    echo "      create [name]       - Create a new wallet with given name"
    echo "      list                - List all wallets"
    echo "      show [name]         - Show details for a specific wallet"
    echo "      recover [name]      - Recover a wallet using mnemonic"
    echo 
    echo -e "  ${GREEN}tx${NC}"
    echo "      send [from] [to] [amount] - Send tokens (amount format: 1000000chaincoin)"
    echo "      delegate [from] [validator] [amount] - Delegate tokens to a validator"
    echo "      withdraw [from] [validator] - Withdraw rewards from a validator"
    echo 
    echo -e "  ${GREEN}query${NC}"
    echo "      balance [address]   - Query balance for address"
    echo "      account [address]   - Query account info"
    echo "      tx [hash]           - Query transaction by hash"
    echo "      block [height]      - Query block at specified height (latest if empty)"
    echo "      validators          - List all active validators"
    echo
    echo -e "  ${GREEN}node${NC}"
    echo "      status              - Query node status"
    echo "      set [node_address]  - Set node address (e.g., tcp://chainos.network:26657)"
    echo
    echo -e "  ${GREEN}advanced${NC}"
    echo "      raw [command...]    - Run raw chainosd commands with auto-applied common flags"
    echo
}

# Wallet management functions
function wallet_create {
    name=$1
    if [ -z "$name" ]; then
        echo -e "${RED}Error: Wallet name is required${NC}"
        echo "Usage: $0 wallet create [name]"
        return 1
    fi
    
    echo -e "${YELLOW}Creating new wallet '$name'...${NC}"
    echo -e "${YELLOW}Keep your mnemonic phrase safe! It's the only way to recover your wallet.${NC}"
    echo
    
    $CHAINOSD keys add "$name" $KEY_FLAGS
    
    if [ $? -eq 0 ]; then
        echo
        echo -e "${GREEN}Wallet created successfully.${NC}"
        echo -e "${YELLOW}If you want to send tokens, your address is shown above.${NC}"
    fi
}

function wallet_list {
    echo -e "${YELLOW}Listing wallets...${NC}"
    $CHAINOSD keys list $KEY_FLAGS
}

function wallet_show {
    name=$1
    if [ -z "$name" ]; then
        echo -e "${RED}Error: Wallet name is required${NC}"
        echo "Usage: $0 wallet show [name]"
        return 1
    fi
    
    echo -e "${YELLOW}Showing wallet details for '$name'...${NC}"
    $CHAINOSD keys show "$name" $KEY_FLAGS
}

function wallet_recover {
    name=$1
    if [ -z "$name" ]; then
        echo -e "${RED}Error: Wallet name is required${NC}"
        echo "Usage: $0 wallet recover [name]"
        return 1
    fi
    
    echo -e "${YELLOW}Recovering wallet '$name'...${NC}"
    echo -e "${YELLOW}You'll be prompted to enter your 24-word mnemonic phrase.${NC}"
    echo
    
    $CHAINOSD keys add "$name" --recover $KEY_FLAGS
    
    if [ $? -eq 0 ]; then
        echo
        echo -e "${GREEN}Wallet recovered successfully.${NC}"
    fi
}

# Transaction functions
function tx_send {
    from=$1
    to=$2
    amount=$3
    
    if [ -z "$from" ] || [ -z "$to" ] || [ -z "$amount" ]; then
        echo -e "${RED}Error: Missing parameters${NC}"
        echo "Usage: $0 tx send [from] [to] [amount]"
        echo "Example: $0 tx send mywallet cosmos1abc...xyz 1000000chaincoin"
        return 1
    fi
    
    echo -e "${YELLOW}Sending tokens from '$from' to '$to'...${NC}"
    $CHAINOSD tx bank send "$from" "$to" "$amount" \
        --gas auto --gas-adjustment 1.4 \
        --broadcast-mode block \
        --yes \
        $TX_FLAGS
    
    if [ $? -eq 0 ]; then
        echo
        echo -e "${GREEN}Transaction sent successfully.${NC}"
        echo -e "${YELLOW}Check the explorer for details.${NC}"
    fi
}

function tx_delegate {
    from=$1
    validator=$2
    amount=$3
    
    if [ -z "$from" ] || [ -z "$validator" ] || [ -z "$amount" ]; then
        echo -e "${RED}Error: Missing parameters${NC}"
        echo "Usage: $0 tx delegate [from] [validator] [amount]"
        echo "Example: $0 tx delegate mywallet cosmosvaloper1abc...xyz 1000000chaincoin"
        return 1
    fi
    
    echo -e "${YELLOW}Delegating tokens from '$from' to validator '$validator'...${NC}"
    $CHAINOSD tx staking delegate "$validator" "$amount" \
        --from "$from" \
        --gas auto --gas-adjustment 1.4 \
        --broadcast-mode block \
        --yes \
        $TX_FLAGS
    
    if [ $? -eq 0 ]; then
        echo
        echo -e "${GREEN}Delegation successful.${NC}"
    fi
}

function tx_withdraw {
    from=$1
    validator=$2
    
    if [ -z "$from" ] || [ -z "$validator" ]; then
        echo -e "${RED}Error: Missing parameters${NC}"
        echo "Usage: $0 tx withdraw [from] [validator]"
        echo "Example: $0 tx withdraw mywallet cosmosvaloper1abc...xyz"
        return 1
    fi
    
    echo -e "${YELLOW}Withdrawing rewards from validator '$validator'...${NC}"
    $CHAINOSD tx distribution withdraw-rewards "$validator" \
        --from "$from" \
        --gas auto --gas-adjustment 1.4 \
        --broadcast-mode block \
        --yes \
        $TX_FLAGS
    
    if [ $? -eq 0 ]; then
        echo
        echo -e "${GREEN}Withdrawal successful.${NC}"
    fi
}

# Query functions
function query_balance {
    address=$1
    
    if [ -z "$address" ]; then
        echo -e "${RED}Error: Address is required${NC}"
        echo "Usage: $0 query balance [address]"
        return 1
    fi
    
    echo -e "${YELLOW}Querying balance for address '$address'...${NC}"
    $CHAINOSD query bank balances "$address" $QUERY_FLAGS
}

function query_account {
    address=$1
    
    if [ -z "$address" ]; then
        echo -e "${RED}Error: Address is required${NC}"
        echo "Usage: $0 query account [address]"
        return 1
    fi
    
    echo -e "${YELLOW}Querying account info for address '$address'...${NC}"
    $CHAINOSD query account "$address" $QUERY_FLAGS
}

function query_tx {
    hash=$1
    
    if [ -z "$hash" ]; then
        echo -e "${RED}Error: Transaction hash is required${NC}"
        echo "Usage: $0 query tx [hash]"
        return 1
    fi
    
    echo -e "${YELLOW}Querying transaction with hash '$hash'...${NC}"
    $CHAINOSD query tx "$hash" $QUERY_FLAGS
}

function query_block {
    height=$1
    
    echo -e "${YELLOW}Querying block${NC}"
    if [ -n "$height" ]; then
        echo -e "${YELLOW}at height '$height'...${NC}"
        $CHAINOSD query block "$height" $QUERY_FLAGS
    else
        echo -e "${YELLOW}at latest height...${NC}"
        $CHAINOSD query block $QUERY_FLAGS
    fi
}

function query_validators {
    echo -e "${YELLOW}Querying active validators...${NC}"
    $CHAINOSD query staking validators $QUERY_FLAGS
}

# Node functions
function node_status {
    echo -e "${YELLOW}Querying node status...${NC}"
    $CHAINOSD status $QUERY_FLAGS
}

function node_set {
    new_node=$1
    
    if [ -z "$new_node" ]; then
        echo -e "${RED}Error: Node address is required${NC}"
        echo "Usage: $0 node set [node_address]"
        echo "Current node: $NODE"
        return 1
    fi
    
    NODE="$new_node"
    TX_FLAGS="--node=$NODE --chain-id=$CHAIN_ID --home=$HOME_DIR --keyring-backend=$KEYRING_BACKEND"
    echo -e "${GREEN}Node address set to '$NODE'${NC}"
}

# Advanced functions
function advanced_raw {
    if [ $# -eq 0 ]; then
        echo -e "${RED}Error: Command required for raw execution${NC}"
        echo "Usage: $0 advanced raw [command...]"
        return 1
    fi
    
    echo -e "${YELLOW}Executing raw command: $CHAINOSD $@ $TX_FLAGS${NC}"
    $CHAINOSD "$@" $TX_FLAGS
}

# Interactive mode main menu
run_interactive_mode() {
    while true; do
        interactive_menu "Main Menu - Select an option:" \
            "Wallet Management" \
            "Send Transaction" \
            "Query Blockchain" \
            "Node Management" \
            "Advanced Commands" \
            "Exit"
            
        case $? in
            0) # Wallet Management
                interactive_wallet_menu
                ;;
            1) # Send Transaction
                interactive_tx_menu
                ;;
            2) # Query Blockchain
                interactive_query_menu
                ;;
            3) # Node Management
                interactive_node_menu
                ;;
            4) # Advanced Commands
                interactive_advanced_menu
                ;;
            5) # Exit
                clear
                exit 0
                ;;
        esac
    done
}

# Interactive wallet management menu
interactive_wallet_menu() {
    while true; do
        # Use double quotes for each menu option to preserve spaces
        interactive_menu "Wallet Management - Select an option:" \
            "Create New Wallet" \
            "List Wallets" \
            "Show Wallet Details" \
            "Recover Wallet" \
            "Return to Main Menu"
            
        case $? in
            0) # Create New Wallet
                name=$(get_input "Enter wallet name")
                if [ -n "$name" ]; then
                    wallet_create "$name"
                    read -p "Press Enter to continue..."
                fi
                ;;
            1) # List Wallets
                wallet_list
                read -p "Press Enter to continue..."
                ;;
            2) # Show Wallet Details
                name=$(get_input "Enter wallet name to display")
                if [ -n "$name" ]; then
                    wallet_show "$name"
                    read -p "Press Enter to continue..."
                fi
                ;;
            3) # Recover Wallet
                name=$(get_input "Enter wallet name for recovery")
                if [ -n "$name" ]; then
                    wallet_recover "$name"
                    read -p "Press Enter to continue..."
                fi
                ;;
            4) # Return to Main Menu
                return
                ;;
        esac
    done
}

# Interactive transaction menu
interactive_tx_menu() {
    while true; do
        interactive_menu "Transaction Operations - Select an option:" \
            "Send Tokens" \
            "Delegate Tokens" \
            "Withdraw Rewards" \
            "Return to Main Menu"
            
        case $? in
            0) # Send Tokens
                from=$(get_input "Enter sender wallet name")
                to=$(get_input "Enter recipient address")
                amount=$(get_input "Enter amount to send (e.g., 1000000uos)")
                if [ -n "$from" ] && [ -n "$to" ] && [ -n "$amount" ]; then
                    tx_send "$from" "$to" "$amount"
                    read -p "Press Enter to continue..."
                fi
                ;;
            1) # Delegate Tokens
                from=$(get_input "Enter delegator wallet name")
                validator=$(get_input "Enter validator address")
                amount=$(get_input "Enter amount to delegate (e.g., 1000000uos)")
                if [ -n "$from" ] && [ -n "$validator" ] && [ -n "$amount" ]; then
                    tx_delegate "$from" "$validator" "$amount"
                    read -p "Press Enter to continue..."
                fi
                ;;
            2) # Withdraw Rewards
                from=$(get_input "Enter delegator wallet name")
                validator=$(get_input "Enter validator address")
                if [ -n "$from" ] && [ -n "$validator" ]; then
                    tx_withdraw "$from" "$validator"
                    read -p "Press Enter to continue..."
                fi
                ;;
            3) # Return to Main Menu
                return
                ;;
        esac
    done
}

# Interactive query menu
interactive_query_menu() {
    while true; do
        interactive_menu "Query Blockchain - Select an option:" \
            "Check Balance" \
            "Query Account Info" \
            "Query Transaction" \
            "Query Block" \
            "List Validators" \
            "Return to Main Menu"
            
        case $? in
            0) # Check Balance
                address=$(get_input "Enter address to check balance")
                if [ -n "$address" ]; then
                    query_balance "$address"
                    read -p "Press Enter to continue..."
                fi
                ;;
            1) # Query Account Info
                address=$(get_input "Enter address to query")
                if [ -n "$address" ]; then
                    query_account "$address"
                    read -p "Press Enter to continue..."
                fi
                ;;
            2) # Query Transaction
                hash=$(get_input "Enter transaction hash")
                if [ -n "$hash" ]; then
                    query_tx "$hash"
                    read -p "Press Enter to continue..."
                fi
                ;;
            3) # Query Block
                height=$(get_input "Enter block height (leave empty for latest)")
                query_block "$height"
                read -p "Press Enter to continue..."
                ;;
            4) # List Validators
                query_validators
                read -p "Press Enter to continue..."
                ;;
            5) # Return to Main Menu
                return
                ;;
        esac
    done
}

# Interactive node menu
interactive_node_menu() {
    while true; do
        interactive_menu "Node Management - Select an option:" \
            "Check Node Status" \
            "Set Node Address" \
            "Return to Main Menu"
            
        case $? in
            0) # Check Node Status
                node_status
                read -p "Press Enter to continue..."
                ;;
            1) # Set Node Address
                address=$(get_input "Enter new node address (e.g., tcp://chainos.network:26657)")
                if [ -n "$address" ]; then
                    node_set "$address"
                    read -p "Press Enter to continue..."
                fi
                ;;
            2) # Return to Main Menu
                return
                ;;
        esac
    done
}

# Interactive advanced menu
interactive_advanced_menu() {
    while true; do
        interactive_menu "Advanced Commands - Select an option:" \
            "Run Raw Command" \
            "Return to Main Menu"
            
        case $? in
            0) # Run Raw Command
                echo -e "${YELLOW}Enter the raw chainosd command to execute:${NC}"
                echo -e "${BLUE}(Common flags will be automatically applied)${NC}"
                read -p "> " -a raw_cmd
                if [ ${#raw_cmd[@]} -gt 0 ]; then
                    advanced_raw "${raw_cmd[@]}"
                    read -p "Press Enter to continue..."
                fi
                ;;
            1) # Return to Main Menu
                return
                ;;
        esac
    done
}

# Main command handling
if [ "$INTERACTIVE" = true ]; then
    run_interactive_mode
    exit 0
fi

case "$1" in
    "wallet")
        case "$2" in
            "create") wallet_create "$3" ;;
            "list") wallet_list ;;
            "show") wallet_show "$3" ;;
            "recover") wallet_recover "$3" ;;
            *) 
                echo -e "${RED}Error: Unknown wallet command: $2${NC}"
                show_usage
                ;;
        esac
        ;;
    "tx")
        case "$2" in
            "send") tx_send "$3" "$4" "$5" ;;
            "delegate") tx_delegate "$3" "$4" "$5" ;;
            "withdraw") tx_withdraw "$3" "$4" ;;
            *) 
                echo -e "${RED}Error: Unknown transaction command: $2${NC}"
                show_usage
                ;;
        esac
        ;;
    "query")
        case "$2" in
            "balance") query_balance "$3" ;;
            "account") query_account "$3" ;;
            "tx") query_tx "$3" ;;
            "block") query_block "$3" ;;
            "validators") query_validators ;;
            *) 
                echo -e "${RED}Error: Unknown query command: $2${NC}"
                show_usage
                ;;
        esac
        ;;
    "node")
        case "$2" in
            "status") node_status ;;
            "set") node_set "$3" ;;
            *) 
                echo -e "${RED}Error: Unknown node command: $2${NC}"
                show_usage
                ;;
        esac
        ;;
    "advanced")
        case "$2" in
            "raw") shift 2; advanced_raw "$@" ;;
            *) 
                echo -e "${RED}Error: Unknown advanced command: $2${NC}"
                show_usage
                ;;
        esac
        ;;
    *)
        show_usage
        ;;
esac

exit 0
