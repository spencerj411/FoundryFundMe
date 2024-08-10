// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

import {console} from "forge-std/Test.sol";

contract HelperConfig is Script {
    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeedAddress;
    }

    NetworkConfig public activeConfig;

    constructor() {
        if (block.chainid == 1) {
            // Mainnet
            activeConfig = NetworkConfig({
                priceFeedAddress: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
            });
        } else if (block.chainid == 11155111) {
            // Sepolia
            activeConfig = NetworkConfig({
                priceFeedAddress: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
        } else if (block.chainid == 300) {
            console.log("ZKSYNC SEPOLIA L2 ROLLUP BLOCKCHAIN DETECTED");
            // zkSync Sepolia testnet (L2 rollup)
            activeConfig = NetworkConfig({
                priceFeedAddress: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
            });
        } else {
            // Local chain
            // 1. Deploy the mock contract
            vm.startBroadcast();
            MockV3Aggregator mockPriceFeedContract = new MockV3Aggregator(
                DECIMALS,
                INITIAL_PRICE
            );
            vm.stopBroadcast();
            // 2. Get address of mock contract and Create NetworkConfig for it and set it as activeConfig
            activeConfig = NetworkConfig({
                priceFeedAddress: address(mockPriceFeedContract)
            });
        }
    }

    function getPriceFeedAddress() public view returns (address) {
        return activeConfig.priceFeedAddress;
    }
}
