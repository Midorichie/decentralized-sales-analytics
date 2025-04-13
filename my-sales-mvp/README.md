# My Sales MVP

A comprehensive sales tracking and commission management system built on the Stacks blockchain using Clarity smart contracts.

## Overview

This project implements a sales management system with tiered commission structures through two interconnected Clarity smart contracts:

1. **Sales Contract**: Records and tracks sales transactions with associated salesperson data
2. **Commission Manager**: Manages tiered commission rates and calculates payouts based on performance

## Key Features

- Record sales transactions with unique IDs
- Track sales by salesperson
- Tiered commission structure based on sales performance
- Role-based access control for administrative functions
- Input validation and security enhancements

## Project Structure

```
my-sales-mvp/
├── contracts/
│   ├── sales-contract.clar       # Sales tracking functionality
│   └── commission-manager.clar   # Commission management functionality
├── tests/
│   ├── sales-contract-test.clar
│   └── commission-manager-test.clar
├── Clarinet.toml                 # Project configuration
└── README.md                     # Project documentation
```

## Smart Contract Functions

### Sales Contract

#### Public Functions
- `add-sale`: Records a new sale with amount, salesperson, and timestamp
  - Enhanced with validation to ensure amount > 0
  - Returns the unique sale ID

#### Read-Only Functions
- `get-total-sales`: Returns the cumulative sales amount
- `get-commission`: Calculates the commission earned by a specific salesperson
- `get-sale`: Retrieves details for a specific sale by ID
- `get-salesperson-sales`: Gets total sales for a specific salesperson

### Commission Manager

#### Administrative Functions (Owner Only)
- `transfer-ownership`: Transfers contract control to a new principal
- `set-commission-tier`: Creates or updates a commission tier with rate and minimum sales
- `assign-tier`: Manually assigns a tier to a specific salesperson

#### Read-Only Functions
- `get-tier-for-sales`: Determines the appropriate tier for a given sales amount
- `calculate-tiered-commission`: Calculates commission based on sales amount and tier
- `get-salesperson-tier`: Gets the assigned tier for a salesperson
- `calculate-salesperson-commission`: Calculates commission using a salesperson's assigned tier
- `get-contract-owner`: Returns the current contract owner
- `get-tier-details`: Returns details for a specific commission tier

## Bug Fixes from Phase 1

- Fixed incorrect access to `total-sales` attribute in the `get-commission` function
- Added proper input validation for sale amounts

## Security Enhancements

- **Access Control**: Administrative functions restricted to the contract owner
- **Input Validation**: Sale amounts must be greater than zero
- **Ownership Management**: Secure ownership transfer functionality
- **Error Handling**: Proper error codes and validation checks

## Commission Tiers (Default)

| Tier ID | Minimum Sales | Commission Rate |
|---------|---------------|-----------------|
| 1       | $0            | 5%              |
| 2       | $10,000       | 7%              |
| 3       | $50,000       | 10%             |

## Development

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet): A Clarity development environment
- [Stacks.js](https://github.com/blockstack/stacks.js): JavaScript library for interacting with the Stacks blockchain

### Getting Started

1. Clone this repository
2. Install Clarinet following the [official instructions](https://github.com/hirosystems/clarinet#installation)
3. Run tests:
   ```
   clarinet test
   ```
4. Start a local development environment:
   ```
   clarinet console
   ```

## License

[MIT License](LICENSE)
