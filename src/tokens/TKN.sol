// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract TKN is ERC20 {
    constructor(
        string memory name,
        string memory symbol,
        uint256 supply
    ) ERC20(name, symbol) {
        _mint(address(this), supply);
    }

    function faucet(uint256 amount) public {
        this.approve(msg.sender, amount);
        transferFrom(address(this), msg.sender, amount);
    }
}
