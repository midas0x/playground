// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../lib/ds-test/src/test.sol";

import "./DappTutorial.sol";

contract DappTutorialTest is DSTest {
    DappTutorial dappTutorial;

    function setUp() public {
        dappTutorial = new DappTutorial();
    }

    function test_withdraw(uint96 amount) public {
        payable(address(dappTutorial)).transfer(amount);
        uint256 preBalance = address(this).balance;
        dappTutorial.withdraw(42);
        uint256 postBalance = address(this).balance;
        assertEq(preBalance + amount, postBalance);
    }

    function testFail_withdraw_wrong_pass() public {
        payable(address(dappTutorial)).transfer(1 ether);
        uint256 preBalance = address(this).balance;
        dappTutorial.withdraw(1);
        uint256 postBalance = address(this).balance;
        assertEq(preBalance + 1 ether, postBalance);
    }

    // function proveFail_withdraw(uint guess) public {
    //     payable(address(dappTutorial)).transfer(1 ether);
    //     uint preBalance = address(this).balance;
    //     dappTutorial.withdraw(guess);
    //     uint postBalance = address(this).balance;
    //     assertEq(preBalance + 1 ether, postBalance);
    // }

    receive() external payable {}
}
