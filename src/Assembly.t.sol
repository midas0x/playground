// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../lib/ds-test/src/test.sol";

import "./Assembly.sol";

contract AssemblyTest is DSTest {
    Assembly private asm;

    function setUp() public {
        asm = new Assembly();
    }

    function testMain() public {
        assertEq(asm.main(), 25);
    }
}
