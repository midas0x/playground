// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import { DSTest } from "../../lib/ds-test/src/test.sol";

import { TKN } from "./TKN.sol";
import { WTKN } from "./WTKN.sol";

contract WTKNTest is DSTest {
    TKN private tkn;
    WTKN private wtkn;
    string private name = "Wrapped Token";
    string private symbol = "WTKN";

    function setUp() public {
        tkn = new TKN("Token", "TKN");
        wtkn = new WTKN(name, symbol, address(tkn));
    }

    function testGeneral() public {
        assertEq(wtkn.name(), name);
        assertEq(wtkn.symbol(), symbol);
    }

    function testWrap() public {
        tkn.mint(address(this), 5);
        tkn.approve(address(wtkn), 5);
        wtkn.depositFor(address(this), 5);

        assertEq(tkn.balanceOf(address(this)), 0);
        assertEq(wtkn.balanceOf(address(this)), 5);
    }

    function testUnwrap() public {
        tkn.mint(address(this), 5);
        tkn.approve(address(wtkn), 5);
        wtkn.depositFor(address(this), 5);
        wtkn.withdrawTo(address(this), 5);

        assertEq(tkn.balanceOf(address(this)), 5);
        assertEq(wtkn.balanceOf(address(this)), 0);
    }
}
