// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Wrapper.sol";

contract WTKN is ERC20, ERC20Wrapper {
    constructor(address underlyingToken) ERC20("Wrapped Token", "WTKN") ERC20Wrapper(IERC20(underlyingToken)) {}
}
