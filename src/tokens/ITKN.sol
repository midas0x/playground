// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

interface ITKN is IERC20 {
    function mint(address account, uint256 amount) external;

    function faucet(uint256 amount) external;
}
