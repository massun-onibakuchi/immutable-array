// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {LibImmutableArray, ImmutableArray} from "src/LibImmutableArray.sol";
import {SoladyTest} from "solady/test/utils/SoladyTest.sol";
import {SSTORE2} from "solady/src/utils/SSTORE2.sol";

import "forge-std/Test.sol";

contract LibImmutableArrayTest is SoladyTest {
    using LibImmutableArray for ImmutableArray;

    ImmutableArray array;

    function testWriteRead() public {
        address[] memory accounts = new address[](3);
        accounts[0] = address(1);
        accounts[1] = address(2);
        accounts[2] = address(3);

        array = LibImmutableArray.__init__(accounts);

        assertGt(array.pointer().code.length, 0, "pointer is empty");
        assertEq(array.length(), 3, "length");
        address[] memory res = array.toArray();
        assertEq(res[0], address(1), "accounts2[0]");
        assertEq(res[1], address(2), "accounts2[1]");
        assertEq(res[2], address(3), "accounts2[2]");

        assertEq(array.at(0), address(1), "at(0)");
        assertEq(array.at(1), address(2), "at(1)");
        assertEq(array.at(2), address(3), "at(2)");
    }

    function testFuzz_WriteRead(address[] calldata accounts) public {
        array = LibImmutableArray.__init__(accounts);

        assertEq(array.length(), accounts.length, "length");

        address[] memory res = array.toArray();
        for (uint256 i = 0; i < accounts.length; i++) {
            assertEq(res[i], accounts[i], "res[i]");
            assertEq(array.at(i), accounts[i], "at(i)");
        }
    }

    function testRevert_IfIndexOutOfBounds(address[] calldata accounts, uint96 i) public {
        vm.assume(i >= accounts.length);
        array = LibImmutableArray.__init__(accounts);
        vm.expectRevert(LibImmutableArray.ImmutableArrayIndexOutOfBounds.selector);
        array.at(i);
    }
}
