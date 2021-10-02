// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import { DSTest } from "../lib/ds-test/src/test.sol";

import { Assembly } from "./Assembly.sol";

contract AssemblyTest is DSTest {
    Assembly private asm;

    function setUp() public {
        asm = new Assembly();
    }

    function testMain() public {
        assertEq(asm.main(), 25);
    }
}
