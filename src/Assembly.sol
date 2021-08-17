// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Assembly {
    function main() external pure returns (uint256) {
        uint8 z = 5;

        assembly {
            function adder(a, b) -> res {
                res := add(a, b)
            }

            function multiplier(a, b) -> res {
                res := mul(a, b)
            }

            function allocate(length) -> pos {
                pos := mload(0x40)
                mstore(0x40, add(pos, length))
            }

            let ptr := allocate(32)

            let x := adder(2, 3) // 2 + 3 = 5
            let y := multiplier(x, z) // 5 * 5 = 25
            mstore(ptr, y)
            return(ptr, 32)
        }
    }
}
