// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../../lib/ds-test/src/test.sol";

import "./TKN.sol";
import "./WTKN.sol";

contract WTKNTest is DSTest {
    TKN private tkn;
    WTKN private wtkn;
    string private name = "Wrapped Token";
    string private symbol = "WTKN";

    function setUp() public {
        tkn = new TKN("Token", "TKN", 10);
        wtkn = new WTKN(name, symbol, address(tkn));
    }

    function testGeneral() public {
        assertEq(wtkn.name(), name);
        assertEq(wtkn.symbol(), symbol);
    }

    function testWrap() public {
        tkn.faucet(5);
        tkn.approve(address(wtkn), 5);
        wtkn.depositFor(address(this), 5);

        assertEq(tkn.balanceOf(address(this)), 0);
        assertEq(wtkn.balanceOf(address(this)), 5);
    }

    function testUnwrap() public {
        tkn.faucet(5);
        tkn.approve(address(wtkn), 5);
        wtkn.depositFor(address(this), 5);
        wtkn.withdrawTo(address(this), 5);

        assertEq(tkn.balanceOf(address(this)), 5);
        assertEq(wtkn.balanceOf(address(this)), 0);
    }
}
