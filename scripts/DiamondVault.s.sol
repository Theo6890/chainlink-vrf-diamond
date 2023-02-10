// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/VrfConsumer.sol";

contract DeployDiamondVault is Script {
    function run() external {
        string memory SEED = vm.envString("SEED");
        uint256 privateKey = vm.deriveKey(SEED, 0);

        vm.startBroadcast(privateKey);

        VrfConsumer diamond = new VrfConsumer();

        vm.stopBroadcast();
    }
}
