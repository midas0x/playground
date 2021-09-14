// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract LogicV1 {
    bool private initialized;
    uint256 private magicNumber;

    function initialize() public {
        require(!initialized, "initialize: Already initialized");

        magicNumber = 0x42;
        initialized = true;
    }

    function setMagicNumber(uint256 _newMagicNumber) public {
        magicNumber = _newMagicNumber;
    }

    function getMagicNumber() public view returns (uint256) {
        return magicNumber;
    }
}
