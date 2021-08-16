// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./TKN.sol";

contract TKNTest is DSTest {
    TKN tkn;

    function setUp() public {
        tkn = new TKN(5);
    }

    function testFaucet() public {
        tkn.faucet(2);
        // 2 with 18 zeros
        uint256 expected = 2000000000000000000;
        assertEq(tkn.balanceOf(address(this)), expected);
    }
}
