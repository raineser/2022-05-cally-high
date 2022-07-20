# Cally

**NFT and ERC20 covered call vaults**

![Github Actions](https://github.com/foundry-rs/forge-template/workflows/Tests/badge.svg)

## Installation

Clone the repo and then run:

```
npm install
forge install
```

## Testing

The original tests have been removed and replaced with critical vulnerabilities only.

## Running Tests


### `File: h1.t.sol`
Requires mainnet forking 

```
forge test --fork-url <alchemy/infura URL> --match testStealFunds

```

### `File: h2.t.sol`

```
forge test --match testInefficiency

```

### `File: h3.t.sol`

```
forge test --match testFakeBalance

```