// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../lib/ds-test/src/test.sol";

interface WETH {
    function balanceOf(address) external returns (uint256);

    function deposit() external payable;
}

contract WethTest is DSTest {
    WETH private weth;

    function setUp() public {
        weth = WETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    }

    function testWrap() public {
        assertEq(weth.balanceOf(address(this)), 0);
        weth.deposit{value: 1 ether}();
        assertEq(weth.balanceOf(address(this)), 1 ether);
    }
}
