// SPDX-License-Identifier: MIT

pragma solidity 0.8.35;

import {AppStore} from "src/AppStore.sol";
// import {AppStoreToken} from "src/mocks/AppStoreToken.sol";
import {Script, console} from "forge-std/Script.sol";

contract DeployAppStore is Script {
    AppStore appStore;

    function run() public returns (AppStore) {
        appStore = new AppStore();

        return appStore;
    }
}
