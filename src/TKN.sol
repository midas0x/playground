// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TKN is ERC20 {
    constructor(uint256 supply) ERC20("Token", "TKN") {
        // 1 token = 1 * (10 ** decimals)
        _mint(address(this), supply * 10**uint256(decimals()));
    }

    function faucet(uint256 amount) public {
        uint256 toMint = amount * 10**uint256(decimals());
        this.approve(msg.sender, toMint);
        transferFrom(address(this), msg.sender, toMint);
    }
}
