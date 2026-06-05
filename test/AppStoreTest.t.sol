// SPDX-License-Identifier: MIT

pragma solidity 0.8.35;

import {AppStore} from "src/AppStore.sol";
import {AppStoreToken} from "src/mocks/AppStoreToken.sol";
import {Test, console} from "forge-std/Test.sol";
import {DeployAppStore} from "script/DeployAppStore.s.sol";

contract AppStoreTest is Test {
    AppStore s_appStore;
    DeployAppStore s_deployer;

    // test users
    address public alice = makeAddr("alice");

    // constants
    uint256 private constant REGISTRATION_FEE = 0.001 ether;

    // invalid edge cases
    uint256[] private INVALID_AMOUNTS = [0, 1, 4, 101, 500, 1000];

    function setUp() external {
        s_deployer = new DeployAppStore();
        s_appStore = s_deployer.run();

        vm.deal(alice, 10 ether);
    }

    function testRegisterDev() public {
        vm.prank(alice);
        s_appStore.registerDev{value: REGISTRATION_FEE}();

        assertEq(true, s_appStore.getIsDev(alice));
    }

    function testRegisterDevRevertsIfNoPayment() public {
        vm.prank(alice);
        vm.expectRevert(AppStore.AppStore__PaymentRequired.selector);
        s_appStore.registerDev{value: 0}();

        assertEq(false, s_appStore.getIsDev(alice));
    }

    function testBuyTokens() public {
        // arrange - act - assert
        uint256 amountToBuy = 10;
        uint256 amountToPay = (REGISTRATION_FEE * amountToBuy) / 10;

        vm.prank(alice);
        s_appStore.buyTokens{value: amountToPay}(amountToBuy);

        assertEq(s_appStore.getTokenBalance(alice), amountToBuy * 10**18);
    }

    function testBuyTokensRevertsIfNoPayment() public {
        uint256 amountToBuy = 10;

        vm.prank(alice);
        vm.expectRevert(AppStore.AppStore__PaymentRequired.selector);
        s_appStore.buyTokens{value: 0}(amountToBuy);

        assertEq(s_appStore.getTokenBalance(alice), 0);
    }

    function testBuyTokensRevertsIfInvalidAmount() public {
        for (uint256 i = 0; i < INVALID_AMOUNTS.length; i++) {
            uint256 amountToPay = (REGISTRATION_FEE * INVALID_AMOUNTS[i]) / 10;

            vm.prank(alice);
            vm.expectRevert(AppStore.AppStore__InvalidAction.selector);
            s_appStore.buyTokens{value: amountToPay}(INVALID_AMOUNTS[i]);

            assertEq(s_appStore.getTokenBalance(alice), 0);
        }
    }
}
