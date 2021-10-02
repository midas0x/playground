// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import { IERC20 } from "../../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { IERC20Metadata } from "../../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol";

interface ITKN is IERC20, IERC20Metadata {
    function mint(address account, uint256 amount) external;

    function faucet(uint256 amount) external;
}
