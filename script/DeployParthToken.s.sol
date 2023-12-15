// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {ParthToken} from "../src/ParthToken.sol";

contract DeployOurToken is Script {
    ParthToken public parthToken;

    function run() external returns (ParthToken) {
        vm.startBroadcast();
        parthToken = new ParthToken();
        vm.stopBroadcast();
        return parthToken;
    }
}
