# <h1 align="center"> Immutable Array </h1>

This is a simple wrapper designed around SSTORE2, serving to emulate immutable arrays. Nothing fancy.

Under the hood, ImmutableArray uses SSTORE2 to store the elements of the array which is known as leveraging _Code-as-Storage_ (CaS) pattern.

### When to use ImmutableArray over Solidity arrays:

If you don't need to change the elements of the array after initialization, you can use ImmutableArray instead of a dynamic array. Initializing immutable arrays can be expensive because it deploys a contract, but accessing entire array is cheaper than static-size arrays.

Not to mention, if you know size of the array at compile time, hardcoding each element as a immutable variable is by far the cheapest option.

## Getting Started

### Example

```solidity
import {LibImmutableArray, ImmutableArray} from "src/LibImmutableArray.sol";

contract ImmutableArrayExample {
    using LibImmutableArray for ImmutableArray;

    /// You can use `immutable` keyword
    ImmutableArray immutable imutArray;

    constructor(address[] memory accounts) {
        // initialize immutable array
        imutArray = LibImmutableArray.__init__(accounts);
    }

    function getArray() external view returns (address[] memory) {
        return imutArray.toArray();
    }

    function getArrayAt(uint256 index) external view returns (address) {
        return imutArray.at(index);
    }
}
```

### Benchmark

> How to reproduce: forge test --mt=testGas

| Length: 3            |                     | Dynamic size array | Static size array | ImmutableArray | Immutable LValue x3 |
| -------------------- | ------------------- | ------------------ | ----------------- | -------------- | ------------------- |
| `getArray()`         | Read entire array   | 15283              | 12813             | 10182          | 6362                |
| Avg. `getArrayAt(i)` | Read single element | 5259               | 4436              | 3985           | 2575                |

### Requirements

The following will need to be installed. Please follow the links and instructions.

- [Foundry](https://github.com/foundry-rs/foundry)

### Quickstart

1. Install dependencies

Once you've cloned and entered into your repository, you need to install the necessary dependencies. In order to do so, simply run:

```shell
forge install
```

2. Build

```bash
forge build
```

3. Test

```bash
forge test -vvv
```

For more information on how to use Foundry, check out the [Foundry Github Repository](https://github.com/foundry-rs/foundry/tree/master/forge) or type `forge help` in your terminal.

### References

[SSTORE2](https://github.com/0xsequence/sstore2)

[SSTORE3](https://github.com/Philogy/sstore3/tree/main)
