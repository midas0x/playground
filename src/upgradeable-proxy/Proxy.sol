// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

/* solhint-disable no-inline-assembly */

library StorageSlot {
    function getAddressAt(bytes32 _slot) internal view returns (address a) {
        assembly {
            a := sload(_slot)
        }
    }

    function setAddressAt(bytes32 _slot, address _address) internal {
        assembly {
            sstore(_slot, _address)
        }
    }
}

contract Proxy {
    bytes32 private constant _IMPL_SLOT =
        bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);

    function setImplementation(address _implementation) public {
        StorageSlot.setAddressAt(_IMPL_SLOT, _implementation);
    }

    function getImplementation() public view returns (address) {
        return StorageSlot.getAddressAt(_IMPL_SLOT);
    }

    function _delegate(address _impl) internal {
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())

            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)

            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 {
                revert(ptr, size)
            }
            default {
                return(ptr, size)
            }
        }
    }

    // solhint-disable-next-line payable-fallback
    fallback() external {
        _delegate(StorageSlot.getAddressAt(_IMPL_SLOT));
    }
}
