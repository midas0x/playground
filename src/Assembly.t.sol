// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./Assembly.sol";

contract AssemblyTest is DSTest {
    Assembly asm;

    function setUp() public {
        asm = new Assembly();
    }

    function testMain() public {
        assertEq(asm.main(), 25);
    }
}
