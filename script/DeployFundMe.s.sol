// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

import {console} from "forge-std/Test.sol";

contract DeployFundMe is Script {
    constructor() {
        console.log("---DeployFundMe");
        console.log(address(this));
        console.log("---");
    }

    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        // anything between this and stopBroadcast, broadcast to the blockchain of your choice (by defining RPC URL when forge create'ing)
        vm.startBroadcast();
        FundMe fundMeContract = new FundMe(helperConfig.getPriceFeedAddress());
        vm.stopBroadcast();
        return fundMeContract;
    }
}
