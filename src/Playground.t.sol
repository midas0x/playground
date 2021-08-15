pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./Playground.sol";

contract PlaygroundTest is DSTest {
    Playground playground;

    function setUp() public {
        playground = new Playground();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
