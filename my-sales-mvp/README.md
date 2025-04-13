# My Sales MVP

A simple sales tracking smart contract built on Stacks blockchain that records sales, calculates commissions, and tracks performance metrics.

## Overview

This project implements a basic sales management system as a Clarity smart contract. It allows for:

- Recording sales transactions with unique IDs
- Tracking sales by salesperson
- Computing commission amounts based on sales performance
- Retrieving total sales figures

## Smart Contract Functions

### Public Functions

- `add-sale`: Records a new sale with the specified amount, salesperson, and timestamp
  - Returns the unique sale ID

### Read-Only Functions

- `get-total-sales`: Returns the cumulative sales amount
- `get-commission`: Calculates the commission earned by a specific salesperson based on their sales and the current commission rate

## Project Structure

```
my-sales-mvp/
├── contracts/
│   └── sales-contract.clar    # Main contract implementation
├── tests/
│   └── sales-contract-test.clar   # Tests for the contract
├── Clarinet.toml              # Project configuration
└── README.md                  # Project documentation
```

## Contract Variables

- `total-sales`: Tracks the cumulative sales amount
- `commission-rate`: Percentage rate used for commission calculations (stored as an integer, e.g., 5 for 5%)
- `sales-records`: Map storing sale details with unique sale IDs
- `sale-counter`: Sequence generator for unique sale IDs

## Events

- `new-sale`: Emitted when a new sale is recorded, containing sale details

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

### Testing

The contract includes tests in the `tests` directory. Run them with:

```
clarinet test
```

## Known Issues

There's a potential issue in the `get-commission` function that references a `map-get? sales-records-all` which may be incorrectly implemented - this should be reviewed before deployment.

## License

[MIT License](LICENSE)
