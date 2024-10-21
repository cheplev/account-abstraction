//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeployMinimal} from "../script/DeployMinimal.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {MinimalAccount} from "../src/ethereum/MinimalAccount.sol";

contract MinimalAccountTest is Test {
    DeployMinimal deployer;
    HelperConfig helperConfig;
    MinimalAccount minimalAccount;
    ERC20Mock usdc;
    uint256 constant AMOUNT = 1e18;
    address randomUser = makeAddr("random");

    function setUp() public {
        deployer = new DeployMinimal();
        (helperConfig, minimalAccount) = deployer.deployMinimalAccount();
        usdc = new ERC20Mock();
    }

    // USDC mint
    // msg.sender -> MinimalAccount 
    // approve amount
    // USDC contract
    // come from entryupoint

    function testOwnerCanExecuteCommands() public {
        assertEq(usdc.balanceOf(address(minimalAccount)), 0);
        address dest = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector, address(minimalAccount), AMOUNT);

        vm.prank(minimalAccount.owner());
        minimalAccount.execute(dest, value, functionData);
        assertEq(usdc.balanceOf(address(minimalAccount)), 1e18);

    }


    function testNonOwnerCannotExecuteCommands() public {
        assertEq(usdc.balanceOf(address(minimalAccount)), 0);
        address dest = address(usdc);
        uint256 value = 0;
        bytes memory functionData = abi.encodeWithSelector(ERC20Mock.mint.selector, address(minimalAccount), AMOUNT);

        vm.prank(randomUser);
        vm.expectRevert(MinimalAccount.MinimalAccount__NotFromEntryPointOrOwner.selector);
        minimalAccount.execute(dest, value, functionData);

    }
}
