// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../lib/ds-test/src/test.sol";

import "./DappTutorial.sol";

contract DappTutorialTest is DSTest {
    DappTutorial private dappTutorial;

    function setUp() public {
        dappTutorial = new DappTutorial();
    }

    function testWithdraw(uint96 amount) public {
        payable(address(dappTutorial)).transfer(amount);
        uint256 preBalance = address(this).balance;
        dappTutorial.withdraw(42);
        uint256 postBalance = address(this).balance;
        assertEq(preBalance + amount, postBalance);
    }

    function testFailWithdrawWrongPass() public {
        payable(address(dappTutorial)).transfer(1 ether);
        uint256 preBalance = address(this).balance;
        dappTutorial.withdraw(1);
        uint256 postBalance = address(this).balance;
        assertEq(preBalance + 1 ether, postBalance);
    }

    // function proveFailWithdraw(uint256 guess) public {
    //     payable(address(dappTutorial)).transfer(1 ether);
    //     uint256 preBalance = address(this).balance;
    //     dappTutorial.withdraw(guess);
    //     uint256 postBalance = address(this).balance;
    //     assertEq(preBalance + 1 ether, postBalance);
    // }

    // solhint-disable-next-line no-empty-blocks
    receive() external payable {}
}
