// SPDX-License-Identifier: MIT

pragma solidity 0.8.35;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AppStoreToken is ERC20 {
    error AppStoreToken__NotMinter(address);
    error AppStoreToken__NotEnoughTokens();

    constructor() ERC20("App Store Token", "AST") {
        isMinter[msg.sender] = true; // white list app store contract as minter of ERC20 token, this is for development, use chainlink in prod
    }

    mapping(address minter => bool canMint) private isMinter;

    function mint(address to, uint256 amount) public {
        if (!isMinter[msg.sender]) {
            revert AppStoreToken__NotMinter(msg.sender);
        }

        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public {
        if (balanceOf(msg.sender) < amount) {
            revert AppStoreToken__NotEnoughTokens();
        }

        _burn(from, amount);
    }
}
