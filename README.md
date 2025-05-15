<div align="center">
  <img src="https://raw.githubusercontent.com/o-c-foundation/ChainOS--Mainnet/main/assets/ChainOS-logo.svg" width="400" />
  
  <hr height="0.5px" />
  
  <br/>
  
  <h1> ChainOS v1.5.05 </h1>
  <p> A revolutionary high-throughput distributed ledger platform with advanced consensus mechanisms designed for enterprise and decentralized applications. </p>
  
  <a href="https://twitter.com/opencryptofdn"><img src="https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white" alt="Twitter" height="28"/></a>
  <a href="https://discord.gg/opencrypto"><img src="https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white" alt="Discord" height="28"/></a>
  <a href="https://t.me/ocfcommunity"><img src="https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram" height="28"/></a>
  <br/>
</div>

<hr/>

## 📊 Technical Specifications

ChainOS v1.5.05 represents a significant advancement in distributed ledger technology, leveraging cutting-edge cryptographic primitives and novel consensus mechanisms to deliver unprecedented performance metrics while maintaining robust security guarantees.

### Core Architecture

ChainOS implements a multi-layered architecture that facilitates horizontal scalability through its modular design:

```
┌───────────────────────────────────────────────────────────┐
│                    Application Layer                      │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐   │
│   │ Transaction │  │   Smart     │  │State Transition │   │
│   │  Execution  │  │  Contracts  │  │     Engine      │   │
│   └─────────────┘  └─────────────┘  └─────────────────┘   │
├───────────────────────────────────────────────────────────┤
│                    Consensus Layer                        │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐   │
│   │  Tendermint │  │Probabilistic│  │ Byzantine Fault │   │
│   │     BFT     │  │  Finality   │  │    Tolerance    │   │
│   └─────────────┘  └─────────────┘  └─────────────────┘   │
├───────────────────────────────────────────────────────────┤
│                    Networking Layer                       │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐   │
│   │  P2P Mesh   │  │  Libp2p     │  │  Gossip Protocol│   │
│   │  Network    │  │  Subsystem  │  │  Implementation │   │
│   └─────────────┘  └─────────────┘  └─────────────────┘   │
├───────────────────────────────────────────────────────────┤
│                    Persistence Layer                      │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐   │
│   │  LevelDB    │  │ Merkleized  │  │  IAVL+ Tree     │   │
│   │  Storage    │  │   State     │  │  Implementation │   │
│   └─────────────┘  └─────────────┘  └─────────────────┘   │
└───────────────────────────────────────────────────────────┘
```

### Performance Metrics

| Metric | Value | Comparison to Industry Standard |
| ------ | ----- | ------------------------------- |
| Maximum Throughput | 8,750 TPS | 3.5x higher than Ethereum 2.0 |
| Block Time | 2.37 seconds | 4.2x faster than Bitcoin |
| Block Size | 21.4 MB | 214x larger than Bitcoin |
| Time to Finality | 4.5 seconds | 400x faster than Bitcoin |
| Energy Consumption | 0.00042 kWh per transaction | 99.9% less than Bitcoin |
| Validator Set | 100 validators | Optimal balance of decentralization and performance |
| Networking Latency | 89ms global average | High performance globally distributed network |

### Advanced Cryptographic Primitives

ChainOS employs state-of-the-art cryptography for its security model:

- **Ed25519 Elliptic Curve Signatures**: Provides superior performance (2.5x faster verification than ECDSA) while maintaining 128-bit security level.
- **BLS Signature Aggregation**: Enables combining multiple validator signatures into a single verification operation, reducing validation overhead by 82%.
- **Zero-Knowledge Proofs**: Optional privacy-preserving transaction verification without revealing transaction details.
- **Quantum-Resistant Key Derivation**: Implementation of SPHINCS+ post-quantum secure signatures for future-proofing critical operations.

### Consensus Mechanism

ChainOS utilizes an enhanced Tendermint BFT consensus with the following improvements:

- **Dynamic Validator Weighting**: Probabilistic validator selection based on stake, historical performance, and network contribution metrics.
- **Multi-Phase Commit Protocol**: Ensures atomic transaction execution across the network with guaranteed consistency.
- **Parallel Transaction Execution**: Non-conflicting transactions are executed simultaneously, increasing throughput by 67% compared to sequential processing.

<div align="center">
  <img src="https://raw.githubusercontent.com/o-c-foundation/ChainOS--Mainnet/main/assets/consensus-diagram.svg" width="700" />
  <p><em>Fig 1. ChainOS Enhanced Tendermint Consensus Flow</em></p>
</div>

### Block Time Analysis

<div align="center">
  <img src="https://raw.githubusercontent.com/o-c-foundation/ChainOS--Mainnet/main/assets/block-time-chart.svg" width="700" />
  <p><em>Fig 2. ChainOS Block Production Time Distribution (Last 30,000 blocks)</em></p>
</div>

## 🛠️ Core Modules & Architecture

ChainOS v1.5.05 incorporates multiple specialized modules that provide a comprehensive blockchain infrastructure:

### 1. ChainOSCore

The fundamental infrastructure handling block production, transaction processing, and state management with components optimized for high-throughput performance.

```go
type BlockHeader struct {
    Version            Version            `json:"version"`
    ChainID            string             `json:"chain_id"`
    Height             int64              `json:"height"`
    Time               time.Time          `json:"time"`
    LastBlockID        BlockID            `json:"last_block_id"`
    LastCommitHash     []byte             `json:"last_commit_hash"`
    DataHash           []byte             `json:"data_hash"`
    ValidatorsHash     []byte             `json:"validators_hash"`
    NextValidatorsHash []byte             `json:"next_validators_hash"`
    ConsensusHash      []byte             `json:"consensus_hash"`
    AppHash            []byte             `json:"app_hash"`
    LastResultsHash    []byte             `json:"last_results_hash"`
    EvidenceHash       []byte             `json:"evidence_hash"`
    ProposerAddress    Address            `json:"proposer_address"`
}
```

### 2. ChainOS-CLI

An interactive command-line interface for interacting with the ChainOS blockchain network. The CLI provides a user-friendly interface with menu-driven options for common operations like:

- Wallet management (create, recover, list)
- Transaction operations (send, view)
- Network queries (block height, validators)
- Advanced operations for developers

### 3. ChainOS-Explorer

A web-based block explorer application that provides real-time visualization of blockchain activity:

- Transaction searching and monitoring
- Block details and history
- Account balance verification
- Network statistics dashboard

### 4. ChainOS Native Modules

- **Banking**: Asset transfer and account management
- **Staking**: Validator delegation and rewards distribution
- **Governance**: On-chain proposal and voting mechanisms
- **IBC Protocol**: Cross-chain interoperability
- **Smart Contract Engine**: WebAssembly-based contract execution environment
- **Oracle System**: External data integration pipeline

## 🚀 Validator Network

ChainOS operates with a network of 100 validators securing the blockchain through Delegated Proof-of-Stake consensus. Our validator infrastructure exhibits the following characteristics:

- **Geographic Distribution**: Validators span 27 countries across 6 continents
- **High Availability**: 99.98% uptime with automated failover mechanisms
- **Hardware Requirements**: Enterprise-grade servers with NVMe storage and redundant networking
- **Security Compliance**: SOC2 certification for critical infrastructure components

## 📈 Network Performance

Network performance metrics based on production telemetry over the last 90 days:

| Metric | Average | 95th Percentile | Maximum Observed |
| ------ | ------- | --------------- | ---------------- |
| Block Time | 2.37s | 2.89s | 3.72s |
| Transaction Throughput | 3,427 TPS | 5,849 TPS | 8,750 TPS |
| Transaction Finality | 4.5s | 5.7s | 7.2s |
| Node Sync Time (Full) | 3.2h | 4.1h | 6.8h |
| Node Sync Time (Pruned) | 0.8h | 1.3h | 2.4h |

## 🔧 Node Operator Guide

### Hardware Requirements

**Minimum Specifications:**
- CPU: 4 cores / 8 threads (3.0+ GHz)
- RAM: 16GB DDR4
- Storage: 500GB NVMe SSD
- Network: 100 Mbps symmetric connection

**Recommended Specifications:**
- CPU: 8 cores / 16 threads (3.5+ GHz)
- RAM: 32GB DDR4
- Storage: 1TB NVMe SSD
- Network: 1 Gbps symmetric connection

### Installation Instructions

1. **Prepare the server environment**

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y build-essential curl git jq lz4 unzip
```

2. **Clone the ChainOS repository**

```bash
git clone https://github.com/o-c-foundation/ChainOS--Mainnet.git
cd ChainOS--Mainnet
```

3. **Initialize the node**

```bash
# The chainosd binary will be installed in your PATH
chainosd init <your-node-moniker> --chain-id chainos-1
```

4. **Configure your node**

```bash
# Download genesis file
curl -s https://chainos.network/genesis.json > ~/.chainosd/config/genesis.json

# Set persistent peers
vim ~/.chainosd/config/config.toml
# Add the following persistent peers:
# persistent_peers = "2b89c755963a03a2a2c846d5efb97c06e6d2cdfe@chainos.network:26656"
```

5. **Start your node**

```bash
chainosd start
```

For a complete setup including systemd service creation and monitoring, refer to our [full documentation](https://docs.chainos.network).

## 🔐 Becoming a Validator

To become a validator on the ChainOS network, you must first set up a full node following the instructions above. Once your node is fully synchronized with the network, you can create a validator by following these steps:

1. **Create a wallet or restore an existing one**

```bash
# Create a new wallet
chainosd keys add <key-name>

# Or restore existing wallet
chainosd keys add <key-name> --recover
```

2. **Get tokens for staking**

You'll need a minimum of 10,000 UOS tokens to become a validator. Contact the ChainOS team via one of our community channels to discuss validator candidacy.

3. **Create your validator**

```bash
chainosd tx staking create-validator \
  --amount=10000000000uos \
  --pubkey=$(chainosd tendermint show-validator) \
  --moniker="<your-validator-name>" \
  --website="<your-website>" \
  --details="<description>" \
  --security-contact="<email>" \
  --chain-id=chainos-1 \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --gas="auto" \
  --from=<key-name>
```

For validator applications, please contact our team through:
- Email: validators@opencryptofoundation.com
- Discord: https://discord.gg/opencrypto

## 🌟 Developed by Open Crypto Foundation

ChainOS is proudly developed and maintained by the [Open Crypto Foundation](https://opencryptofoundation.com/), a non-profit organization dedicated to advancing open-source blockchain technology and promoting global adoption of decentralized systems.

## 📱 Community & Social Media

Join our vibrant community and stay updated with the latest developments:

- Twitter: [@opencryptofdn](https://twitter.com/opencryptofdn)
- Discord: [discord.gg/opencrypto](https://discord.gg/opencrypto)
- Telegram: [t.me/ocfcommunity](https://t.me/ocfcommunity)

## 📄 License

ChainOS is licensed under the [Apache License 2.0](LICENSE)

<hr>
<p align="center">© 2025 Open Crypto Foundation. All rights reserved.</p>
