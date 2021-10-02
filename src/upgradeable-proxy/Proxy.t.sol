// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

/* solhint-disable reason-string */
/* solhint-disable avoid-low-level-calls */

import { DSTest } from "../../lib/ds-test/src/test.sol";

import { Proxy } from "./Proxy.sol";
import { LogicV1 } from "./LogicV1.sol";
import { LogicV2 } from "./LogicV2.sol";

contract ProxyTest is DSTest {
    Proxy private proxy;
    LogicV1 private logicV1;
    LogicV2 private logicV2;

    function setUp() public {
        proxy = new Proxy();
        logicV1 = new LogicV1();
        logicV2 = new LogicV2();
        proxy.setImplementation(address(logicV1));
        (bool success, ) = address(proxy).call(
            abi.encodeWithSignature("initialize()")
        );
        require(success);
    }

    function testGeneral() public {
        assertEq(proxy.getImplementation(), address(logicV1));
    }

    function testLogicV1ContractCall() public {
        uint256 magicNumber = 0x42;

        (, bytes memory result) = address(proxy).call(
            abi.encodeWithSignature("getMagicNumber()")
        );
        bytes memory expected = abi.encodePacked(magicNumber);
        assertEq0(result, expected);
    }

    function testLogicV2ContractCall() public {
        bool success;
        uint256 magicNumber = 0x33;
        proxy.setImplementation(address(logicV2));

        (success, ) = address(proxy).call(
            abi.encodeWithSignature("setMagicNumber(uint256)", 0x66)
        );
        require(success);
        (success, ) = address(proxy).call(abi.encodeWithSignature("doMagic()"));
        require(success);

        (, bytes memory result) = address(proxy).call(
            abi.encodeWithSignature("getMagicNumber()")
        );
        bytes memory expected = abi.encodePacked(magicNumber);
        assertEq0(result, expected);
    }
}
