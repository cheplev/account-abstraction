//SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {MinimalAccount} from "../src/ethereum/MinimalAccount.sol";

contract HelperConfig is Script {
    error HelperConfig__InvalidChainId();

    struct NetworkConfig {
        address entrytPoint;
        address account;
    }

    uint256 constant ETH_SEPOLIA_CHAIN_ID = 11155111;

    uint256 constant ZKSYNC_SEPOLIA_CHAIN_ID = 300;

    uint256 constant LOCAL_CHAIN_ID = 31337;

    address constant BURNER_OWNER = 0xE0364e443201A57F0Be0a9e27f3b064e815a4006;

    NetworkConfig public localNetworkConfig;

    mapping(uint256 chainId => NetworkConfig) public networkconfigs;

    constructor() {
        networkconfigs[ETH_SEPOLIA_CHAIN_ID] = getEthSepoliaConfig();
    }

    function getConfigByChainId(uint256 chainId) public view returns (NetworkConfig memory) {
        if (chainId == LOCAL_CHAIN_ID) {
            return getOrCreateConfig();
        } else if (networkconfigs[chainId].entrytPoint != address(0)) {
            return networkconfigs[chainId];
        } else {
            revert HelperConfig__InvalidChainId();
        }
    }

    function getConfig() public view returns (NetworkConfig memory) {
        return getConfigByChainId(block.chainid);
    }

    function getEthSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({entrytPoint: 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789, account: BURNER_OWNER});
    }

    function getZkSyncSepoliaConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({entrytPoint: address(0), account: BURNER_OWNER});
    }

    function getOrCreateConfig() public view returns (NetworkConfig memory) {
        if (localNetworkConfig.account != address(0)) {
            return localNetworkConfig;
        }

        return NetworkConfig({entrytPoint: address(0), account: BURNER_OWNER});
    }
}
