// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {SSTORE2} from "solady/src/utils/SSTORE2.sol";

// length (uint96) + pointer (uint160)
type ImmutableArray is uint256;

library LibImmutableArray {
    uint256 constant ONE_WORD = 32;
    uint256 constant ADDRESS_TYPE_SIZE = 20;

    error ImmutableArrayIndexOutOfBounds();

    function __init__(address[] memory accounts) internal returns (ImmutableArray imuArray) {
        // This is not packed so not efficient.
        // For more efficient implementation, you should use `SSTORE2` directly.
        address ptr = SSTORE2.write(abi.encode(accounts));
        assembly {
            // (accounts.length << 160) | uint256(uint160(ptr))
            imuArray := or(shl(160, mload(accounts)), ptr)
        }
    }

    function length(ImmutableArray self) internal pure returns (uint256 len) {
        assembly {
            len := shr(160, self)
        }
    }

    function pointer(ImmutableArray self) internal pure returns (address) {
        return address(uint160(ImmutableArray.unwrap(self)));
    }

    function toArray(ImmutableArray self) internal view returns (address[] memory) {
        return abi.decode(SSTORE2.read(pointer(self)), (address[]));
    }

    function at(ImmutableArray self, uint256 index) internal view returns (address addr) {
        // equivalent to: if (index >= length(self)) revert ImmutableArrayIndexOutOfBounds();
        assembly {
            // If `index` is out of bounds, revert
            let len := shr(160, self)
            if gt(add(index, 1), len) {
                // Store the function selector of `ImmutableArrayIndexOutOfBounds()`.
                mstore(0x00, 0x267296e3)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }
        }
        // ???(32bytes) + length(32bytes) + elements[0], elements[1], elements[2], ...
        // read 1 word using SSTORE2 at [element: element + 0x20]
        bytes memory ret = SSTORE2.read(pointer(self), (2 + index) * ONE_WORD, (3 + index) * ONE_WORD);
        // read a element following the length.
        assembly {
            addr := mload(add(ret, 0x20))
        }
    }
}
