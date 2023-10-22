// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "src/example/Example.sol";

interface IArrayExample {
    function getArray() external view returns (address[] memory);

    function getArrayAt(uint256 index) external view returns (address);
}

abstract contract ExampleBaseTest is Test {
    IArrayExample example;
    address[] testArray = [address(0x1234), address(0x5678), address(0x9ABC)];

    function testGas_getArray() public view virtual {
        uint256 _before = gasleft();
        example.getArray();
        console2.log("gas usage: ", _before - gasleft());
    }

    function testGas_getArrayAt_Avg() public view {
        uint256 used;
        for (uint256 i = 0; i < testArray.length; i++) {
            uint256 _before = gasleft();
            example.getArrayAt(i);
            used += _before - gasleft() - 2;
        }
        console2.log("gas usage avg: ", used / testArray.length);
    }

    function test_getArray() public virtual {
        address[] memory result = example.getArray();
        for (uint256 i = 0; i < testArray.length; i++) {
            assertEq(result[i], testArray[i]);
        }
    }

    function testGas_getArrayAt() public view {
        example.getArrayAt(2);
    }

    function test_getArrayAt() public {
        for (uint256 i = 0; i < testArray.length; i++) {
            assertEq(example.getArrayAt(i), testArray[i]);
        }
    }

    function testRevert_IfGetArrayAtOutOfBounds() public {
        vm.expectRevert();
        example.getArrayAt(100);
    }
}

contract ImmutableArray3ExampleTest is ExampleBaseTest {
    function setUp() public {
        uint256 _before = gasleft();
        example = IArrayExample(address(new ImmutableArrayExample(testArray)));
        console2.log("gas usage: ", _before - gasleft());
    }
}

contract ImmutableArray6ExampleTest is ImmutableArray3ExampleTest {
    constructor() {
        testArray =
            [address(0x1234), address(0x5678), address(0x9ABC), address(0xcafe), address(0xbabe), address(0xdead)];
    }
}

contract DynamicSizeArray3ExampleTest is ExampleBaseTest {
    function setUp() public {
        uint256 _before = gasleft();
        example = IArrayExample(address(new DynamicSizeArrayExample(testArray)));
        console2.log("gas usage: ", _before - gasleft());
    }
}

contract DynamicSizeArray6ExampleTest is DynamicSizeArray3ExampleTest {
    constructor() {
        testArray =
            [address(0x1234), address(0x5678), address(0x9ABC), address(0xcafe), address(0xbabe), address(0xdead)];
    }
}

contract StaticSizeArray3ExampleTest is ExampleBaseTest {
    function setUp() public {
        address[3] memory _testArray = [testArray[0], testArray[1], testArray[2]];
        uint256 _before = gasleft();
        example = IArrayExample(address(new StaticSizeArray3Example(_testArray)));
        console2.log("gas usage: ", _before - gasleft());
    }

    function test_getArray() public override {
        address[3] memory result = StaticSizeArray3Example(address(example)).getArray();
        for (uint256 i = 0; i < testArray.length; i++) {
            assertEq(result[i], testArray[i]);
        }
    }

    function testGas_getArray() public view override {
        uint256 _before = gasleft();
        StaticSizeArray3Example(address(example)).getArray();
        console2.log("gas usage: ", _before - gasleft());
    }
}

contract StaticSizeArray6ExampleTest is ExampleBaseTest {
    constructor() {
        testArray =
            [address(0x1234), address(0x5678), address(0x9ABC), address(0xcafe), address(0xbabe), address(0xdead)];
    }

    function setUp() public {
        address[6] memory _testArray =
            [testArray[0], testArray[1], testArray[2], testArray[3], testArray[4], testArray[5]];
        uint256 _before = gasleft();
        example = IArrayExample(address(new StaticSizeArray6Example(_testArray)));
        console2.log("gas usage: ", _before - gasleft());
    }

    function test_getArray() public override {
        address[6] memory result = StaticSizeArray6Example(address(example)).getArray();
        for (uint256 i = 0; i < testArray.length; i++) {
            assertEq(result[i], testArray[i]);
        }
    }

    function testGas_getArray() public view override {
        uint256 _before = gasleft();
        StaticSizeArray6Example(address(example)).getArray();
        console2.log("gas usage: ", _before - gasleft());
    }
}

contract ImmutableValue3ExampleTest is ExampleBaseTest {
    function setUp() public {
        address[3] memory _testArray = [testArray[0], testArray[1], testArray[2]];
        uint256 _before = gasleft();
        example = IArrayExample(address(new ImmutableValue3Example(_testArray)));
        console2.log("gas usage: ", _before - gasleft());
    }

    function test_getArray() public override {
        address[3] memory result = ImmutableValue3Example(address(example)).getArray();
        for (uint256 i = 0; i < testArray.length; i++) {
            assertEq(result[i], testArray[i]);
        }
    }

    function testGas_getArray() public view override {
        uint256 _before = gasleft();
        ImmutableValue3Example(address(example)).getArray();
        console2.log("gas usage: ", _before - gasleft());
    }
}
