// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "contracts/token/ERC20/ERC20.sol" ;

contract VoltaCoin is SafeERC20 {
    constructor() SafeERC20("VoltaCoin", "VOLT") {
        _mint(msg.sender, 100000);
    }
}