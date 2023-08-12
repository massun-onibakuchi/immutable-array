// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {LibImmutableArray, ImmutableArray} from "../LibImmutableArray.sol";

contract ImmutableArrayExample {
    using LibImmutableArray for ImmutableArray;

    ImmutableArray immutable imutArray;

    constructor(address[] memory accounts) {
        imutArray = LibImmutableArray.__init__(accounts);
    }

    function getArray() external view returns (address[] memory) {
        return imutArray.toArray();
    }

    function getArrayAt(uint256 index) external view returns (address) {
        return imutArray.at(index);
    }
}

contract DynamicSizeArrayExample {
    address[] array;

    constructor(address[] memory accounts) {
        array = accounts;
    }

    function getArray() external view returns (address[] memory) {
        return array;
    }

    function getArrayAt(uint256 index) external view returns (address) {
        return array[index];
    }
}

contract StaticSizeArray3Example {
    address[3] array;

    constructor(address[3] memory accounts) {
        array = accounts;
    }

    function getArray() external view returns (address[3] memory) {
        return array;
    }

    function getArrayAt(uint256 index) external view returns (address) {
        return array[index];
    }
}

contract StaticSizeArray6Example {
    address[6] array;

    constructor(address[6] memory accounts) {
        array = accounts;
    }

    function getArray() external view returns (address[6] memory) {
        return array;
    }

    function getArrayAt(uint256 index) external view returns (address) {
        return array[index];
    }
}

contract ImmutableValue3Example {
    address immutable account1;
    address immutable account2;
    address immutable account3;

    constructor(address[3] memory accounts) {
        account1 = accounts[0];
        account2 = accounts[1];
        account3 = accounts[2];
    }

    function getArray() public view returns (address[3] memory) {
        return [account1, account2, account3];
    }

    function getArrayAt(uint256 index) external view returns (address) {
        return getArray()[index];
    }
}
