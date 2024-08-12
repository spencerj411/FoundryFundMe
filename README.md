# FoundryFundMe
A simple smart contract where people can fund the contract and the contract owner can withdraw the whole balance.

# Getting Started

## Requirements
-   [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
    -   You'll know you did it right if you can run  `git --version`  and you see a response like  `git version x.x.x`
-   [foundry](https://getfoundry.sh/)
    -   You'll know you did it right if you can run  `forge --version`  and you see a response like  `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`
## Quickstart
```
git clone https://github.com/spencerj411/FoundryFundMe.git
cd FoundryFundMe
forge install foundry-rs/forge-std
forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit
```
## Deploy
```
forge script script/DeployFundMe.s.sol --rpc-url ${RPC_URL} --broadcast --private-key ${PRIVATE_KEY}
```
## Run All Tests
```
forge test -vvvv
```

