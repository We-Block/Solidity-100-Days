# Code Examples

那么这个章节中我们会提供一系列代码样例，首先是一个官方manual中的Subcurrency Example

# Solidity 合约：Coin

## 代码详细介绍

该智能合约是一个简单的虚拟货币系统，用户可以创建新的货币并将其发送给他人。

### 代码概述

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Coin {
    address public minter;
    mapping(address => uint) public balances;

    event Sent(address from, address to, uint amount);

    constructor() {
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    error InsufficientBalance(uint requested, uint available);

    function send(address receiver, uint amount) public {
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
```

## 一、代码详细解析

我们一步步来分析这段代码：

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
```
上述两行代码为文件头部信息。第一行注释是 Solidity 文件的许可声明。第二行是 Solidity 语言的版本声明，^0.8.4 代表该代码兼容0.8.4及以上版本的 Solidity 编译器。

```solidity
contract Coin {
```
该行定义了一个名为 "Coin" 的智能合约。

```solidity
address public minter;
mapping(address => uint) public balances;
```
上述两行定义了两个状态变量。`minter` 变量用于存储货币的铸币者的地址，它是 public 类型，可以通过合约方法直接访问。`balances` 是一个映射，用于存储每个地址的币的余额。

```solidity
event Sent(address from, address to, uint amount);
```
这行定义了一个名为 Sent 的事件，当成功发送币时将触发此事件。事件有三个参数，发送者的地址，接收者的地址，以及发送的数量。

```solidity
constructor() {
    minter = msg.sender;
}
```
这是构造函数，创建合约时会自动执行。在这里，它将 `minter` 变量设置为创建合约的地址。

```solidity
function mint(address receiver, uint amount) public {
    require(msg.sender == minter);
    balances[receiver] += amount;
}
```
这是一个名为 `mint` 的公共函数，它接受两个参数，接收者的地址和数量。这个函数只有 `minter` 才能调用。它会向指定的接收者添加指定数量的币。

```solidity
error InsufficientBalance(uint requested, uint available);
```
这是一个自定义错误，当用户试图发送超过其余额的币时，会触发这个错误。

```solidity
function send(address receiver, uint amount) public {
    if (amount > balances[msg.sender])
        revert InsufficientBalance({
            requested: amount,
            available: balances[msg.sender]
        });

    balances[msg.sender] -= amount;
    balances[receiver] += amount;
    emit Sent(msg.sender, receiver, amount);
}
```
这是一个名为 `send` 的公共函数，用于发送币。如果发送数量大于发送者的余额，将触发 `InsufficientBalance` 错误。否则，会从发送者的余额中扣除相应数量的币，添加到接收者的余额中，并触发 `Sent` 事件。

## 二、代码不足及优化建议

1. **权限管理**：在这个合约中，只有合约的创建者可以铸币，这个权限较为单一。我们可以增加一套权限管理系统，比如可以设置多个地址具有铸币的权限，或者可以将铸币权限转让给其他地址。

具体实现代码如下：

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Coin {
    address public minter;
    mapping(address => bool) public minters;

    // 其他代码...
    
    constructor() {
        minter = msg.sender;
        minters[minter] = true;
    }

    function addMinter(address _minter) public {
        require(msg.sender == minter, "Only initial minter can add minters.");
        minters[_minter] = true;
    }

    function mint(address receiver, uint amount) public {
        require(minters[msg.sender], "Only minters can mint.");
        balances[receiver] += amount;
    }

    // 其他代码...
}
```

在这个优化版本中，我们增加了一个 minters 映射，用于记录哪些地址具有铸币权限。在 mint 函数中，我们检查调用者是否有铸币权限，而不再是检查调用者是否为合约的创建者。我们还增加了一个 addMinter 函数，只有合约的创建者可以调用，用于添加新的铸币者。

3. **合约升级**：这个合约缺乏升级机制，一旦合约部署，就无法更改。这可能导致在发现问题或需要增加新功能时无法及时响应。我们可以通过代理合约、可升级合约等方式来添加合约升级的功能。

## 三、增加新功能

1. **增加销毁货币的功能**：可以添加一个 `burn` 函数，用于销毁某个地址的一部分货币，这样可以调整货币的总供应量。

具体实现代码如下：

```solidity
function burn(uint amount) public {
    require(balances[msg.sender] >= amount, "Insufficient balance to burn.");
    balances[msg.sender] -= amount;
}
```

这个 `burn` 函数首先检查调用者的余额是否足够，然后从调用者的余额中扣除指定数量的货币。

2. **增加货币发行上限**：可以设置一个货币发行上限，在 `mint` 函数中检查已发行货币的总量，当达到上限时禁止继续发行。

具体实现代码如下：

```solidity
uint public maxSupply;
uint public totalSupply;

constructor(uint _maxSupply) {
    minter = msg.sender;
    maxSupply = _maxSupply;
    totalSupply = 0;
}

function mint(address receiver, uint amount) public {
    require(msg.sender == minter);
    require(totalSupply + amount <= maxSupply, "Exceeds max supply.");
    totalSupply += amount;
    balances[receiver] += amount;
}
```

在这个优化版本中，我们在构造函数中设置了 `maxSupply`，并将 `totalSupply` 初始化为 0。在 `mint` 函数中，我们检查新铸币后的总供应量是否超过上限，如果没有超过，就增加 `totalSupply` 并给接收者发币。

3. **增加权限管理系统**：可以添加一个系统，让 `minter` 能够授予或者剥夺其他地址的铸币和发送货币的权限。

4. **增加交易记录**：每次交易时，可以将交易记录保存下来，这样可以方便用户查看自己的交易历史。
