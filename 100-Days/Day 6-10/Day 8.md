# Solidity 中的内置全局变量和函数

Solidity 是一种智能合约编程语言，它提供了一些特殊的变量和函数，可以让开发者获取区块链的信息或者执行一些通用的操作。这些变量和函数总是存在于全局命名空间中，不需要导入或声明，可以直接在合约中使用。本文将介绍一些常用的内置全局变量和函数，以及它们的作用和用法。

## 区块和交易属性

区块和交易属性是一些与当前区块或交易相关的变量，它们可以反映出区块链的状态和行为。以下是一些常见的区块和交易属性：

- `blockhash(uint blockNumber) returns (bytes32)`：返回指定区块号的区块哈希值，只能用于最近 256 个区块且不包括当前区块，否则返回 0。
- `block.basefee (uint)`：返回当前区块的基础费用，参考 EIP-3198 和 EIP-1559。
- `block.chainid (uint)`：返回当前链的 ID。
- `block.coinbase (address)`：返回挖出当前区块的矿工地址。
- `block.difficulty (uint)`：返回当前区块的难度值。
- `block.gaslimit (uint)`：返回当前区块的 gas 限额。
- `block.number (uint)`：返回当前区块的区块号。
- `block.timestamp (uint)`：返回当前区块的时间戳，即从 unix epoch 开始到当前区块以秒计的时间。
- `gasleft() returns (uint256)`：返回剩余的 gas 数量。
- `msg.data (bytes)`：返回完整的 calldata，即调用数据。
- `msg.sender (address)`：返回消息发送者的地址，即当前调用者。
- `msg.sig (bytes4)`：返回 calldata 的前 4 字节，即函数标识符。
- `msg.value (uint)`：返回随消息发送的 wei 的数量，即转账金额。
- `tx.gasprice (uint)`：返回交易的 gas 价格。
- `tx.origin (address)`：返回交易发起者的地址，即完整的调用链的最开始。

注意，对于每一个外部函数调用，包括对库函数的调用，所有 msg 成员的值都会变化。另外，在链下计算合约时，不应该假定 block.* 和 tx.* 是指任何特定区块或交易。这些值是由执行合约的 EVM 实现提供的，可以是任意的。

另外，不要依赖 block.timestamp 和 blockhash 产生随机数，除非你明确知道自己在做什么。时间戳和区块哈希在一定程度上都可能受到挖矿矿工影响。例如，挖矿社区中的恶意矿工可以用某个给定的哈希来运行赌场合约的 payout 函数，而如果他们没收到钱，还可以用一个不同的哈希重新尝试。当前区块的时间戳必须严格大于最后一个区块的时间戳，但这里能确保也需要它是在权威链上的两个连续区块。

还有一点要注意，基于可扩展因素，区块哈希不是对所有区块都有效。你仅仅可以访问最近 256 个区块的哈希，其余的哈希均为零。

下面是一个使用部分区块和交易属性的代码例子：

```solidity
pragma solidity ^0.8.0;

contract BlockAndTx {
    // 定义一个事件来记录每次调用合约时发送者、金额、剩余 gas、时间戳等信息
    event Caller(address sender, uint value, uint gasLeft, uint timestamp);

    // 定义一个函数来触发事件，并返回当前区块号、难度、gas 限额等信息
    function getInfo() public returns (uint, uint, uint) {
        // 触发事件
        emit Caller(msg.sender, msg.value, gasleft(), block.timestamp);
        // 返回信息
        return (block.number, block.difficulty, block.gaslimit);
    }
}
```

## ABI 编码和解码函数

ABI 编码和解码函数是一些与 ABI（Application Binary Interface）相关的函数，它们可以对数据进行编码或解码，以便在合约之间进行传递或存储。以下是一些常见的 ABI 编码和解码函数：

- `abi.decode(bytes memory encodedData, (...)) returns (...)`：对给定数据进行 ABI 解码，并指定解码后数据类型作为第二个参数。例如：`(uint a, uint[2] memory b, bytes memory c) = abi.decode(data, (uint, uint[2], bytes))`。
- `abi.encode(...) returns (bytes memory)`：对给定参数进行 ABI 编码，并返回编码后数据。
- `abi.encodePacked(...) returns (bytes memory)`：对给定参数执行紧打包编码，并返回编码后数据。注意紧打包编码可能会有歧义！
- `abi.encodeWithSelector(bytes4 selector, ...) returns (bytes memory)`：对给定参数进行 ABI 编码，并以给定函数选择器作为起始 4 字节数据一起返回。
- `abi.encodeWithSignature(string memory signature, ...) returns (bytes memory)`：相当于 `abi.encodeWithSelector(bytes4(keccak256(bytes(signature))), ...)`。
- `abi.encodeCall(function functionPointer, (...)) returns (bytes memory)`：对函数指针及其参数进行 ABI 编码，并执行完整类型检查。结果与 `abi.encodeWithSelector(functionPointer.selector, ...)` 相同。

注意，这些编码函数可以用来构造函数调用数据而不实际进行调用。此外，`keccak256(abi.encodePacked(a, b))` 是一种计算结构化数据哈希值（尽管我们也应该注意使用不同函数参数类型也有可能引起“哈希冲突”） 的方式，而不推荐使用 `keccak256(a, b)`。

下面是一个使用部分 ABI 编码和解码函数的代码例子：

```solidity
pragma solidity ^0.8.0;

contract ABIEncodeDecode {
    // 定义一个结构体类型
    struct Data {
        uint a;
        bytes32 b;
        address c;
    }

    // 定义一个事件来记录编码后数据
    event EncodedData(bytes data);

    // 定义一个事件来记录解码后数据
    event DecodedData(uint a, bytes32 b, address c);

    // 定义一个函数来演示如何使用 ABI 编解码
    function demo() public {
        // 创建一个结构体实例
        Data memory d = Data(1, "Hello", msg.sender);
        // 对结构体进行 ABI 编码
        bytes memory encoded = abi.encode(d.a, d.b, d.c);
        // 触发事件
        emit EncodedData(encoded);
        // 对编码后数据进行 ABI 解码
        (uint a, bytes32 b, address c) = abi.decode(encoded, (uint, bytes32, address));
        // 触发事件
        emit DecodedData(a, b, c);
    }
}
```

这个代码例子展示了如何使用 `abi.encode` 和 `abi.decode` 函数来对一个结构体类型的数据进行编码和解码。首先，我们创建了一个结构体实例 `d`，并用 `abi.encode` 函数将它的三个成员变量 `a`，`b` 和 `c` 进行编码，得到一个字节类型的变量 `encoded`。然后，我们用 `emit` 语句触发了一个事件 `EncodedData`，将编码后的数据作为参数传递。接着，我们用 `abi.decode` 函数将编码后的数据进行解码，得到三个变量 `a`，`b` 和 `c`，它们的类型和值与原来的结构体实例 `d` 的成员变量相同。最后，我们用 `emit` 语句触发了另一个事件 `DecodedData`，将解码后的数据作为参数传递。

这个代码例子可以在 Remix IDE 中运行和测试。你可以部署合约，并调用 `demo` 函数，然后在日志中查看两个事件的输出。您也可以修改结构体类型或编解码函数的参数，来尝试不同的情况。

## abi.encodePacked 和 abi.encodeWithSelector 的区别

`abi.encodePacked` 和 `abi.encodeWithSelector` 都是用来对给定参数进行编码的函数，但是它们有一些区别：

- `abi.encodePacked` 是用来执行紧打包编码的，也就是说，它不会对参数进行 32 字节的填充，而是按照它们的原始长度拼接在一起。这样可以节省空间，但是也可能造成歧义。例如，`abi.encodePacked(uint8(1), uint16(2))` 和 `abi.encodePacked(uint16(1), uint8(2))` 的结果都是 `0x0102`。因此，使用 `abi.encodePacked` 时要注意参数的类型和顺序。
- `abi.encodeWithSelector` 是用来对给定参数进行 ABI 编码，并在前面加上一个 4 字节的函数选择器的。函数选择器是由函数签名的哈希值的前 4 字节组成的，它可以用来标识一个函数。使用 `abi.encodeWithSelector` 可以构造一个函数调用数据，而不实际进行调用。例如，`abi.encodeWithSelector(bytes4(keccak256("add(uint256,uint256)")), 1, 2)` 的结果是 `0x771602f700000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000002`，其中 `0x771602f7` 是函数选择器，后面是两个参数的 ABI 编码。

下面是一个使用 `abi.encodePacked` 和 `abi.encodeWithSelector` 的代码例子：

```solidity
pragma solidity ^0.8.0;

contract PackedAndSelector {
    // 定义一个事件来记录编码后数据
    event EncodedData(bytes data);

    // 定义一个函数来演示如何使用 abi.encodePacked
    function demoPacked() public view returns (bytes memory result) {
        // 对几个不同类型和长度的参数进行紧打包编码
        result = abi.encodePacked(uint8(1), uint16(2), bytes1("a"), bytes2("bc"), address(this));
        // 触发事件
        emit EncodedData(result);
    }

    // 定义一个函数来演示如何使用 abi.encodeWithSelector
    function demoSelector() public view returns (bytes memory result) {
        // 对一个函数指针及其参数进行 ABI 编码，并加上函数选择器
        result = abi.encodeWithSelector(this.add.selector, 1, 2);
        // 触发事件
        emit EncodedData(result);
    }

    // 定义一个辅助函数，用于生成函数选择器
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }
}
```

这个代码例子也可以在 Remix IDE 中运行和测试。你可以部署合约，并分别调用 `demoPacked` 和 `demoSelector` 函数，然后在日志中查看事件的输出。你也可以修改参数或函数指针，来尝试不同的情况。

紧打包编码的一个主要目的是为了计算结构化数据的哈希值。例如，如果你想用 `keccak256` 函数来生成一个唯一的标识符，你可以用 `abi.encodePacked` 来将多个参数拼接在一起，然后传递给 `keccak256`。这样可以避免对每个参数单独计算哈希值，然后再拼接的麻烦。紧打包编码也可以节省空间，因为它不会对参数进行 32 字节的填充，而是按照它们的原始长度拼接在一起。

但是，紧打包编码也有一些缺点和风险。首先，紧打包编码可能会造成歧义，因为不同类型和长度的参数可能会产生相同的编码结果。例如，`abi.encodePacked(uint8(1), uint16(2))` 和 `abi.encodePacked(uint16(1), uint8(2))` 的结果都是 `0x0102`。因此，使用紧打包编码时要注意参数的类型和顺序，以及是否有可能发生哈希冲突。其次，紧打包编码不遵循 ABI 规范，因此它不能用于与其他合约进行交互或存储数据。如果你想要与其他合约进行通信或持久化数据，你应该使用 ABI 编码而不是紧打包编码。

ABI 编码的一个主要目的是为了与其他合约进行交互或存储数据。例如，如果你想要调用另一个合约的函数，你可以用 `abi.encode` 或 `abi.encodeWithSelector` 来构造函数调用数据，然后传递给 `call` 或 `delegatecall` 等低级函数。这样可以实现动态的函数调用，而不需要知道另一个合约的接口。或者，如果你想要将多个参数打包成一个字节类型的变量，然后存储到 `bytes` 或 `bytes32` 类型的状态变量中，你也可以用 `abi.encode` 来实现。这样可以节省存储空间，因为你只需要一个状态变量来存储多个参数。

但是，ABI 编码也有一些缺点和限制。首先，ABI 编码会对参数进行 32 字节的填充，这样会增加编码后数据的长度，从而消耗更多的 gas。因此，如果你只是想计算结构化数据的哈希值，而不需要与其他合约交互或存储数据，你可以考虑使用紧打包编码来节省 gas。其次，ABI 编码不支持所有的类型，例如映射类型、函数类型、循环引用类型等。因此，如果你想要编码这些类型的参数，你需要自己实现一种编码规则，或者转换成其他支持的类型。

而 `abi.encodeWithSelector` 的一个主要目的是为了构造函数调用数据，而不实际进行调用。例如，如果你想要通过 `call` 或 `delegatecall` 等低级函数来调用另一个合约的函数，你可以用 `abi.encodeWithSelector` 来生成函数选择器和参数的编码，然后传递给低级函数。这样可以实现动态的函数调用，而不需要知道另一个合约的接口。函数选择器是由函数签名的哈希值的前 4 字节组成的，它可以用来标识一个函数。你可以通过 `this.functionName.selector` 或 `bytes4(keccak256("functionName(type1,type2,...)"))` 来获取函数选择器。

同样的，`abi.encodeWithSelector` 也有一些缺点和风险。使用 `abi.encodeWithSelector` 构造函数调用数据时要注意安全性问题，例如重入攻击、未知函数调用等。你应该检查返回值和错误处理，并避免将用户输入作为函数选择器。