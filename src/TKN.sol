// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract TKN is ERC20 {
    constructor(
        string memory name,
        string memory symbol,
        uint256 supply
    ) ERC20(name, symbol) {
        // 1 token = 1 * (10 ** decimals)
        _mint(address(this), supply * 10**uint256(decimals()));
    }

    function faucet(uint256 amount) public {
        uint256 toMint = amount * 10**uint256(decimals());
        this.approve(msg.sender, toMint);
        transferFrom(address(this), msg.sender, toMint);
    }
}
