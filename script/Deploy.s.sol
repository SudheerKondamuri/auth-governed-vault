// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import "forge-std/console2.sol";
import "contracts/AuthorizationManager.sol";
import "contracts/SecureVault.sol";

contract CounterScript is Script {

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        AuthorizationManager authManager = new AuthorizationManager(deployer);

        SecureVault secureVault = new SecureVault(address(authManager));

        vm.stopBroadcast();
        console2.log("AuthorizationManager_Address:",address(authManager));
        console2.log("SecureVault_Address:",address(secureVault));

    }
}
