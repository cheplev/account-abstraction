// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {MinimalAccount} from "../src/ethereum/MinimalAccount.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployMinimal is Script {
    HelperConfig helperConfig;

    function run() external {
        deployMinimalAccount();
    }

    function deployMinimalAccount() public returns (HelperConfig, MinimalAccount) {
        helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        vm.startBroadcast();
        MinimalAccount minimalAccount = new MinimalAccount(config.entrytPoint);
        minimalAccount.transferOwnership(msg.sender);
        vm.stopBroadcast();
        return (helperConfig, minimalAccount);
    }
}
