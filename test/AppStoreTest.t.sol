// SPDX-License-Identifier: MIT

pragma solidity 0.8.35;

import {AppStore} from "src/AppStore.sol";
import {AppStoreToken} from "src/mocks/AppStoreToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployAppStore} from "script/DeployAppStore.s.sol";

contract AppStoreTest {
    AppStore s_appStore;
    DeployAppStore s_deployer;
    AppStoreToken s_appStoreToken;
    address public alice;

    // test users

    function setUp() external {
        alice = makeAddr("alice");
        (s_appStore, s_appStoreToken) = s_deployer.run();
    }

    function testRegisterDev() public {
        s_appStore.registerDev();
    }
}