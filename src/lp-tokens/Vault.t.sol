// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import { DSTest } from "../../lib/ds-test/src/test.sol";

import { Vault } from "./Vault.sol";
import { IVault } from "./IVault.sol";
import { TKN } from "../tokens/TKN.sol";
import { ITKN } from "../tokens/ITKN.sol";

contract User {
    IVault private vault;

    constructor(IVault _vault) {
        vault = _vault;
    }

    function approve(
        address _spender,
        ITKN _token,
        uint256 _amount
    ) public {
        _token.approve(_spender, _amount);
    }

    function deposit(uint256 _amount) public {
        vault.deposit(_amount);
    }

    function withdraw(uint256 _amount) public {
        vault.withdraw(_amount);
    }
}

contract VaultTest is DSTest {
    TKN private token;
    Vault private vault;
    User private alice;
    User private bob;
    User private carol;
    User private dave;

    function setUp() public {
        token = new TKN("A Token", "aTKN");
        vault = new Vault(token);
        alice = new User(vault);
        bob = new User(vault);
        carol = new User(vault);
        dave = new User(vault);
    }

    function testLPTokenMetadata() public {
        assertEq(vault.name(), "LP A Token");
        assertEq(vault.symbol(), "lpaTKN");
    }

    function testSingleUser() public {
        uint256 amount = 30 ether;

        token.mint(address(alice), amount);

        // Deposit #1 (alice)
        alice.approve(address(vault), token, 10 ether);
        alice.deposit(10 ether);
        assertEq(token.balanceOf(address(alice)), 20 ether);
        assertEq(token.balanceOf(address(vault)), 10 ether);
        assertEq(vault.balanceOf(address(alice)), 10 ether);

        // Deposit #2 (alice)
        alice.approve(address(vault), token, 20 ether);
        alice.deposit(20 ether);
        assertEq(token.balanceOf(address(alice)), 0 ether);
        assertEq(token.balanceOf(address(vault)), 30 ether);
        assertEq(vault.balanceOf(address(alice)), 30 ether);

        // Withdraw #1 (alice)
        alice.withdraw(20 ether);
        assertEq(token.balanceOf(address(alice)), 20 ether);
        assertEq(token.balanceOf(address(vault)), 10 ether);
        assertEq(vault.balanceOf(address(alice)), 10 ether);

        // Withdraw #2 (alice)
        alice.withdraw(10 ether);
        assertEq(token.balanceOf(address(alice)), 30 ether);
        assertEq(token.balanceOf(address(vault)), 0 ether);
        assertEq(vault.balanceOf(address(alice)), 0 ether);
    }

    function testMultipleUsers() public {
        uint256 amount = 30 ether;

        token.mint(address(alice), amount);
        token.mint(address(bob), amount);

        // Deposit #1 (alice & bob)
        alice.approve(address(vault), token, 10 ether);
        alice.deposit(10 ether);
        bob.approve(address(vault), token, 20 ether);
        bob.deposit(20 ether);
        assertEq(token.balanceOf(address(alice)), 20 ether);
        assertEq(token.balanceOf(address(bob)), 10 ether);
        assertEq(token.balanceOf(address(vault)), 30 ether);
        assertEq(vault.balanceOf(address(alice)), 10 ether);
        assertEq(vault.balanceOf(address(bob)), 20 ether);

        // Deposit #2 (alice & bob)
        alice.approve(address(vault), token, 20 ether);
        alice.deposit(20 ether);
        bob.approve(address(vault), token, 10 ether);
        bob.deposit(10 ether);
        assertEq(token.balanceOf(address(alice)), 0 ether);
        assertEq(token.balanceOf(address(bob)), 0 ether);
        assertEq(token.balanceOf(address(vault)), 60 ether);
        assertEq(vault.balanceOf(address(alice)), 30 ether);
        assertEq(vault.balanceOf(address(bob)), 30 ether);

        // Withdraw #1 (alice & bob)
        alice.withdraw(20 ether);
        bob.withdraw(10 ether);
        assertEq(token.balanceOf(address(alice)), 20 ether);
        assertEq(token.balanceOf(address(bob)), 10 ether);
        assertEq(token.balanceOf(address(vault)), 30 ether);
        assertEq(vault.balanceOf(address(alice)), 10 ether);
        assertEq(vault.balanceOf(address(bob)), 20 ether);

        // Withdraw #2 (alice & bob)
        alice.withdraw(10 ether);
        bob.withdraw(20 ether);
        assertEq(token.balanceOf(address(alice)), 30 ether);
        assertEq(token.balanceOf(address(bob)), 30 ether);
        assertEq(token.balanceOf(address(vault)), 0 ether);
        assertEq(vault.balanceOf(address(alice)), 0 ether);
        assertEq(vault.balanceOf(address(bob)), 0 ether);
    }

    function testMultipleUsersProfit1() public {
        uint256 amount = 30 ether;

        token.mint(address(alice), amount);
        token.mint(address(bob), amount);

        // Deposit (alice & bob)
        alice.approve(address(vault), token, 30 ether);
        alice.deposit(30 ether);
        bob.approve(address(vault), token, 30 ether);
        bob.deposit(30 ether);
        assertEq(token.balanceOf(address(alice)), 0 ether);
        assertEq(token.balanceOf(address(bob)), 0 ether);
        assertEq(token.balanceOf(address(vault)), 60 ether);
        assertEq(vault.balanceOf(address(alice)), 30 ether);
        assertEq(vault.balanceOf(address(bob)), 30 ether);

        // Profit
        vault.profit(30 ether);
        assertEq(token.balanceOf(address(alice)), 0 ether);
        assertEq(token.balanceOf(address(bob)), 0 ether);
        assertEq(token.balanceOf(address(vault)), 90 ether);
        assertEq(vault.balanceOf(address(alice)), 30 ether);
        assertEq(vault.balanceOf(address(bob)), 30 ether);

        // Withdraw (alice & bob)
        alice.withdraw(30 ether);
        bob.withdraw(30 ether);
        assertEq(token.balanceOf(address(alice)), 45 ether);
        assertEq(token.balanceOf(address(bob)), 45 ether);
        assertEq(token.balanceOf(address(vault)), 0 ether);
        assertEq(vault.balanceOf(address(alice)), 0 ether);
        assertEq(vault.balanceOf(address(bob)), 0 ether);
    }

    function testMultipleUsersProfit2() public {
        uint256 amount = 30 ether;

        token.mint(address(alice), amount);
        token.mint(address(bob), amount);
        token.mint(address(carol), amount);

        // Deposit (alice & bob)
        alice.approve(address(vault), token, 30 ether);
        alice.deposit(30 ether);
        bob.approve(address(vault), token, 30 ether);
        bob.deposit(30 ether);
        assertEq(token.balanceOf(address(alice)), 0 ether);
        assertEq(token.balanceOf(address(bob)), 0 ether);
        assertEq(token.balanceOf(address(carol)), 30 ether);
        assertEq(token.balanceOf(address(vault)), 60 ether);
        assertEq(vault.balanceOf(address(alice)), 30 ether);
        assertEq(vault.balanceOf(address(bob)), 30 ether);
        assertEq(vault.balanceOf(address(carol)), 0 ether);

        // Profit
        vault.profit(30 ether);
        assertEq(token.balanceOf(address(alice)), 0 ether);
        assertEq(token.balanceOf(address(bob)), 0 ether);
        assertEq(token.balanceOf(address(carol)), 30 ether);
        assertEq(token.balanceOf(address(vault)), 90 ether);
        assertEq(vault.balanceOf(address(alice)), 30 ether);
        assertEq(vault.balanceOf(address(bob)), 30 ether);
        assertEq(vault.balanceOf(address(carol)), 0 ether);

        // Deposit (carol)
        carol.approve(address(vault), token, 30 ether);
        carol.deposit(30 ether);
        assertEq(token.balanceOf(address(alice)), 0 ether);
        assertEq(token.balanceOf(address(bob)), 0 ether);
        assertEq(token.balanceOf(address(carol)), 0 ether);
        assertEq(token.balanceOf(address(vault)), 120 ether);
        assertEq(vault.balanceOf(address(alice)), 30 ether);
        assertEq(vault.balanceOf(address(bob)), 30 ether);
        assertEq(vault.balanceOf(address(carol)), 20 ether);

        // Withdraw (alice, bob & carol)
        alice.withdraw(30 ether);
        bob.withdraw(30 ether);
        carol.withdraw(20 ether);
        assertEq(token.balanceOf(address(alice)), 45 ether);
        assertEq(token.balanceOf(address(bob)), 45 ether);
        assertEq(token.balanceOf(address(carol)), 30 ether);
        assertEq(token.balanceOf(address(vault)), 0 ether);
        assertEq(vault.balanceOf(address(alice)), 0 ether);
        assertEq(vault.balanceOf(address(bob)), 0 ether);
        assertEq(vault.balanceOf(address(carol)), 0 ether);
    }

    function testMultipleUsersProfit3() public {
        uint256 amount = 30 ether;

        token.mint(address(alice), amount);
        token.mint(address(bob), amount);
        token.mint(address(carol), amount);
        token.mint(address(dave), amount);

        // Deposit (alice & bob)
        alice.approve(address(vault), token, 30 ether);
        alice.deposit(30 ether);
        bob.approve(address(vault), token, 30 ether);
        bob.deposit(30 ether);
        assertEq(token.balanceOf(address(alice)), 0 ether);
        assertEq(token.balanceOf(address(bob)), 0 ether);
        assertEq(token.balanceOf(address(carol)), 30 ether);
        assertEq(token.balanceOf(address(dave)), 30 ether);
        assertEq(token.balanceOf(address(vault)), 60 ether);
        assertEq(vault.balanceOf(address(alice)), 30 ether);
        assertEq(vault.balanceOf(address(bob)), 30 ether);
        assertEq(vault.balanceOf(address(carol)), 0 ether);
        assertEq(vault.balanceOf(address(dave)), 0 ether);

        // Profit
        vault.profit(30 ether);
        assertEq(token.balanceOf(address(alice)), 0 ether);
        assertEq(token.balanceOf(address(bob)), 0 ether);
        assertEq(token.balanceOf(address(carol)), 30 ether);
        assertEq(token.balanceOf(address(dave)), 30 ether);
        assertEq(token.balanceOf(address(vault)), 90 ether);
        assertEq(vault.balanceOf(address(alice)), 30 ether);
        assertEq(vault.balanceOf(address(bob)), 30 ether);
        assertEq(vault.balanceOf(address(carol)), 0 ether);
        assertEq(vault.balanceOf(address(dave)), 0 ether);

        // Deposit (carol)
        carol.approve(address(vault), token, 30 ether);
        carol.deposit(30 ether);
        assertEq(token.balanceOf(address(alice)), 0 ether);
        assertEq(token.balanceOf(address(bob)), 0 ether);
        assertEq(token.balanceOf(address(carol)), 0 ether);
        assertEq(token.balanceOf(address(dave)), 30 ether);
        assertEq(token.balanceOf(address(vault)), 120 ether);
        assertEq(vault.balanceOf(address(alice)), 30 ether);
        assertEq(vault.balanceOf(address(bob)), 30 ether);
        assertEq(vault.balanceOf(address(carol)), 20 ether);
        assertEq(vault.balanceOf(address(dave)), 0 ether);

        // Profit
        vault.profit(30 ether);
        assertEq(token.balanceOf(address(alice)), 0 ether);
        assertEq(token.balanceOf(address(bob)), 0 ether);
        assertEq(token.balanceOf(address(carol)), 0 ether);
        assertEq(token.balanceOf(address(dave)), 30 ether);
        assertEq(token.balanceOf(address(vault)), 150 ether);
        assertEq(vault.balanceOf(address(alice)), 30 ether);
        assertEq(vault.balanceOf(address(bob)), 30 ether);
        assertEq(vault.balanceOf(address(carol)), 20 ether);
        assertEq(vault.balanceOf(address(dave)), 0 ether);

        // Deposit (dave)
        dave.approve(address(vault), token, 30 ether);
        dave.deposit(30 ether);
        assertEq(token.balanceOf(address(alice)), 0 ether);
        assertEq(token.balanceOf(address(bob)), 0 ether);
        assertEq(token.balanceOf(address(carol)), 0 ether);
        assertEq(token.balanceOf(address(dave)), 0 ether);
        assertEq(token.balanceOf(address(vault)), 180 ether);
        assertEq(vault.balanceOf(address(alice)), 30 ether);
        assertEq(vault.balanceOf(address(bob)), 30 ether);
        assertEq(vault.balanceOf(address(carol)), 20 ether);
        assertEq(vault.balanceOf(address(dave)), 16 ether);

        // Withdraw (alice, bob, carol & dave)
        alice.withdraw(30 ether);
        bob.withdraw(30 ether);
        carol.withdraw(20 ether);
        dave.withdraw(16 ether);
        assertEq(token.balanceOf(address(alice)), 56250000000000000000 wei);
        assertEq(token.balanceOf(address(bob)), 56250000000000000000 wei);
        assertEq(token.balanceOf(address(carol)), 37500000000000000000 wei);
        assertEq(token.balanceOf(address(dave)), 30 ether);
        assertEq(token.balanceOf(address(vault)), 0 ether);
        assertEq(vault.balanceOf(address(alice)), 0 ether);
        assertEq(vault.balanceOf(address(bob)), 0 ether);
        assertEq(vault.balanceOf(address(carol)), 0 ether);
        assertEq(vault.balanceOf(address(dave)), 0 ether);
    }
}
