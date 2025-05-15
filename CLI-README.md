# ChainOS CLI Guide

The ChainOS CLI is an interactive command-line interface designed to simplify interactions with the ChainOS blockchain. It provides a user-friendly menu-driven interface for common operations as well as direct command execution.

## Features

- Interactive menu system for easy navigation
- Wallet management (create, list, show details, recover)
- Transaction operations (send tokens, delegate, withdraw rewards)
- Blockchain queries (balance, account info, transactions, blocks)
- Node management (status, configuration)
- Advanced operations for developers

## Installation

1. Make sure the `chainos-cli.sh` script is executable:
   ```bash
   chmod +x chainos-cli.sh
   ```

2. Ensure the ChainOS daemon (`chainosd`) is in your PATH or in the `cmd/chainosd/` directory.

## Usage

### Interactive Mode

To start the CLI in interactive mode:

```bash
./chainos-cli.sh
```

This will display the main menu with options for:
- Wallet Management
- Transactions
- Queries
- Node Management
- Advanced Operations

Navigate through the menus by entering the number corresponding to your choice.

### Direct Command Mode

You can also execute commands directly:

```bash
./chainos-cli.sh [command] [subcommand] [arguments]
```

#### Examples:

**Create a new wallet:**
```bash
./chainos-cli.sh wallet create mynewwallet
```

**Check account balance:**
```bash
./chainos-cli.sh query balance mywalletname
```

**Send tokens:**
```bash
./chainos-cli.sh tx send mywallet recipient-address 1000chaincoin
```

## Main Commands

### Wallet Commands

- `wallet create <name>` - Create a new wallet
- `wallet list` - List all wallets
- `wallet show <name>` - Show details of a specific wallet
- `wallet recover <name>` - Recover a wallet using mnemonic

### Transaction Commands

- `tx send <from> <to> <amount>` - Send tokens
- `tx delegate <delegator> <validator> <amount>` - Delegate tokens to a validator
- `tx withdraw <delegator> <validator>` - Withdraw rewards

### Query Commands

- `query balance <address>` - Check account balance
- `query account <address>` - Show account information
- `query tx <hash>` - Look up a transaction by hash
- `query block <height>` - Get block at specified height
- `query validators` - List active validators

### Node Commands

- `node status` - Check node status
- `node set <url>` - Set node connection URL

### Advanced Commands

- `advanced raw <command>` - Execute raw chainosd commands

## Configuration

The CLI uses the following default settings, which can be modified in the script:

- Node: `tcp://chainos.network:26657`
- Chain ID: `chainos-1`
- Fee denomination: `chaincoin`
- Home directory: `$HOME/.chainosd`
- Keyring backend: `test` (use `file` for production)

## Troubleshooting

If you encounter issues:

1. Ensure the `chainosd` binary is accessible
2. Check your node connection settings
3. Verify your wallet exists and has sufficient funds for transactions
4. For advanced operations, refer to the ChainOS documentation

For more information, visit [https://docs.chainos.network](https://docs.chainos.network)
