// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../lib/ds-test/src/test.sol";

import "./TKN.sol";

contract TKNTest is DSTest {
    TKN private tkn;
    string private name = "Token";
    string private symbol = "TKN";

    function setUp() public {
        tkn = new TKN(name, symbol, 5);
    }

    function testGeneral() public {
        assertEq(tkn.name(), name);
        assertEq(tkn.symbol(), symbol);
    }

    function testFaucet() public {
        tkn.faucet(2);
        // 2 with 18 zeros
        uint256 expected = 2000000000000000000;
        assertEq(tkn.balanceOf(address(this)), expected);
    }
}
