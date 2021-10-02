// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import { Ownable } from "../../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import { ERC20 } from "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

import { ITKN } from "./ITKN.sol";

contract TKN is ITKN, ERC20, Ownable {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {} // solhint-disable-line no-empty-blocks

    function mint(address account, uint256 amount) external override onlyOwner {
        _mint(account, amount);
    }

    function faucet(uint256 amount) external override {
        _mint(msg.sender, amount);
    }
}
