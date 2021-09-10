// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../lib/ds-test/src/test.sol";

import "./TKN.sol";
import "./WTKN.sol";

contract WTKNTest is DSTest {
    TKN tkn;
    WTKN wtkn;
    string name = "Wrapped Token";
    string symbol = "WTKN";

    function setUp() public {
        tkn = new TKN("Token", "TKN", 1000);
        wtkn = new WTKN(name, symbol, address(tkn));
    }

    function testGeneral() public {
        assertEq(wtkn.name(), name);
        assertEq(wtkn.symbol(), symbol);
    }

    function testWrap() public {
        // 10 with 18 zeros
        uint256 amount = 10000000000000000000;

        tkn.faucet(10);
        tkn.approve(address(wtkn), amount);
        wtkn.depositFor(address(this), amount);

        assertEq(tkn.balanceOf(address(this)), 0);
        assertEq(wtkn.balanceOf(address(this)), amount);
    }

    function testUnwrap() public {
        // 10 with 18 zeros
        uint256 amount = 10000000000000000000;

        tkn.faucet(10);
        tkn.approve(address(wtkn), amount);
        wtkn.depositFor(address(this), amount);
        wtkn.withdrawTo(address(this), amount);

        assertEq(tkn.balanceOf(address(this)), amount);
        assertEq(wtkn.balanceOf(address(this)), 0);
    }
}
