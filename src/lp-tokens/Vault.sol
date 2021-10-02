// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import { ERC20 } from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

import { IVault } from "./IVault.sol";
import { ITKN } from "../tokens/ITKN.sol";

// Formulas for LP Token minting and burning are adaptions of what Uniswap v1 and Uniswap v2 implements
// Uniswap v1: https://hackmd.io/@HaydenAdams/HJ9jLsfTz
// Uniswap v2: https://uniswap.org/whitepaper.pdf (Section 3.4)

contract Vault is ERC20, IVault {
    ITKN private underlying;

    constructor(ITKN _underlying)
        ERC20(
            string(abi.encodePacked("LP ", _underlying.name())),
            string(abi.encodePacked("lp", _underlying.symbol()))
        )
    {
        underlying = _underlying;
    }

    function deposit(uint256 _amount) external override {
        uint256 toMint;
        uint256 reserve = underlying.balanceOf(address(this));
        if (reserve == 0) {
            toMint = _amount;
        } else {
            toMint = (totalSupply() * _amount) / reserve;
        }
        underlying.transferFrom(msg.sender, address(this), _amount);
        _mint(msg.sender, toMint);
    }

    function withdraw(uint256 _amount) external override {
        uint256 reserve = underlying.balanceOf(address(this));
        uint256 toSend = (reserve * _amount) / totalSupply();
        underlying.transfer(msg.sender, toSend);
        _burn(msg.sender, _amount);
    }

    function profit(uint256 _amount) external override {
        underlying.faucet(_amount);
    }
}
