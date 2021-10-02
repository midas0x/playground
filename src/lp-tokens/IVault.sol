// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

interface IVault {
    function deposit(uint256 _amount) external;

    function withdraw(uint256 _amount) external;

    function profit(uint256 _amount) external;
}
