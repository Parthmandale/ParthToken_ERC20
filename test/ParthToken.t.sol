//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";

// import {DeployParthToken1} from "../script/DeployParthToken1.s.sol"; // here it is giving err or because of wrong path the correct path is ../script/DeployParthToken1.s.sol

import {ParthToken} from "../src/ParthToken.sol";

contract ParthTokenTest is Test {
    ParthToken parthToken;

    address USER1 = makeAddr("user1");
    address USER2 = makeAddr("user2");

    function setUp() external {
        // DeployParthToken deployParthToken = new DeployParthToken();
        // parthToken = DeployParthToken.run();
    }
}
