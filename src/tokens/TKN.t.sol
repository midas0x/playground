// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../../lib/ds-test/src/test.sol";

import "./TKN.sol";

contract TKNTest is DSTest {
    TKN private tkn;
    string private name = "Token";
    string private symbol = "TKN";

    function setUp() public {
        tkn = new TKN(name, symbol, 10);
    }

    function testGeneral() public {
        assertEq(tkn.name(), name);
        assertEq(tkn.symbol(), symbol);
    }

    function testFaucet() public {
        tkn.faucet(5);
        assertEq(tkn.balanceOf(address(this)), 5);
    }
}
