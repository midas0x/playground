// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../../lib/ds-test/src/test.sol";

import "./TKN.sol";

// solhint-disable-next-line no-empty-blocks
contract User {

}

contract TKNTest is DSTest {
    TKN private tkn;
    User private alice;
    string private name = "Token";
    string private symbol = "TKN";

    function setUp() public {
        tkn = new TKN(name, symbol);
        alice = new User();
    }

    function testGeneral() public {
        assertEq(tkn.name(), name);
        assertEq(tkn.symbol(), symbol);
    }

    function testFaucet() public {
        tkn.mint(address(this), 10 ether);
        assertEq(tkn.balanceOf(address(this)), 10 ether);
        tkn.mint(address(alice), 20 ether);
        assertEq(tkn.balanceOf(address(alice)), 20 ether);
    }
}
