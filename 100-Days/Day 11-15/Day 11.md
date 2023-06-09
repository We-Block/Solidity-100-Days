# Solidity 中的构造函数和回退函数

## 什么是构造函数？

构造函数是一种特殊的函数，它在合约创建时执行一次，用于初始化合约的状态变量或执行一些其他操作。构造函数是可选的，一个合约只能有一个构造函数，不支持重载。构造函数的名称必须是 `constructor`，并且可以指定可见性修饰符（默认为 `public`）。构造函数也可以接受参数，这些参数可以在创建合约时通过 ABI 编码传递。

例如，下面的合约定义了一个带有两个参数的构造函数，用于设置合约的所有者和名称：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract MyContract {
    address public owner;
    string public name;

    // 构造函数
    constructor(address _owner, string memory _name) {
        owner = _owner;
        name = _name;
    }
}
```

构造函数除了用于初始化合约的状态变量或执行一些其他操作之外，还有一些高级的用法，例如：

- 构造函数可以使用 `immutable` 修饰符来声明不可变的状态变量，这些变量在构造函数中被赋值，然后在合约的生命周期中保持不变。这样可以节省 gas，因为不可变的状态变量会被编译器替换为字面值，而不是从存储中读取。
- 构造函数可以使用 `modifier` 修饰符来定义一些通用的逻辑，例如检查权限、验证参数、触发事件等。这样可以避免重复代码，提高可读性和可维护性。
- 构造函数可以使用 `try` / `catch` 语句来处理创建其他合约时可能发生的异常。这样可以避免合约创建失败导致整个交易回滚，也可以根据不同的错误类型做出相应的处理。

例如，下面的合约展示了构造函数的一些高级用法：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

// 定义一个 modifier
modifier onlyOwner {
    require(msg.sender == owner, "Not owner");
    _;
}

contract MyContract {
    // 定义一个 immutable 变量
    uint256 public immutable creationTime;
    // 定义一个普通变量
    address public owner;

    // 使用 modifier 和参数
    constructor(address _owner) onlyOwner {
        owner = _owner;
        // 给 immutable 变量赋值
        creationTime = block.timestamp;
    }

    // 使用 try / catch 创建另一个合约
    function createChild() public {
        try new Child() {
            // 成功创建
            emit ChildCreated();
        } catch Error(string memory reason) {
            // 捕获到 revert 或 require 的错误信息
            emit ChildCreationFailed(reason);
        } catch (bytes memory lowLevelData) {
            // 捕获到其他低级错误
            emit ChildCreationFailedBytes(lowLevelData);
        }
    }

    // 定义一些事件
    event ChildCreated();
    event ChildCreationFailed(string reason);
    event ChildCreationFailedBytes(bytes data);
}

contract Child {
    // 定义一个构造函数，可能会抛出异常
    constructor() {
        require(msg.sender != address(0), "Invalid sender");
        revert("Just fail");
    }
}
```

## 什么是回退函数？

回退函数是一种没有名称和参数的函数，它在合约收到没有匹配任何其他函数的消息时执行。回退函数可以用于接收以太币或执行一些默认的逻辑。回退函数也是可选的，一个合约只能有一个回退函数，不支持重载。回退函数必须使用 `fallback` 关键字声明，并且可以指定可见性修饰符（默认为 `external`）。回退函数也可以使用 `payable` 修饰符来接收以太币。

例如，下面的合约定义了一个回退函数，用于记录合约收到的以太币数量：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract MyContract {
    uint256 public totalReceived;

    // 回退函数
    fallback() external payable {
        totalReceived += msg.value;
    }
}
```

## 构造函数和回退函数有什么区别？

构造函数和回退函数都是一种特殊的函数，但它们有以下几点区别：

- 构造函数只在合约创建时执行一次，而回退函数在合约收到没有匹配任何其他函数的消息时执行。
- 构造函数必须使用 `constructor` 关键字声明，而回退函数必须使用 `fallback` 关键字声明。
- 构造函数可以接受参数，而回退函数不能接受参数。
- 构造函数可以指定任何可见性修饰符（默认为 `public`），而回退函数只能指定 `external` 可见性修饰符（默认为 `external`）。
- 构造函数不需要使用 `payable` 修饰符来接收以太币，而回退函数需要使用 `payable` 修饰符来接收以太币。

## 构造函数和回退函数有什么用途？

构造函数和回退函数都有各自的用途，如下：

- 构造函数可以用于初始化合约的状态变量或执行一些其他操作，例如验证参数、设置权限、注册事件等。
- 回退函数可以用于接收以太币或执行一些默认的逻辑，例如转发消息、触发事件、抛出异常等。

## 如何调用构造函数和回退函数？

构造函数和回退函数都有各自的调用方式，如下：

- 构造函数在创建合约时自动调用，不需要显式调用。如果构造函数有参数，可以在创建合约时通过 ABI 编码传递。
- 回退函数在合约收到没有匹配任何其他函数的消息时自动调用，不需要显式调用。如果要发送以太币给合约，可以直接使用 `transfer` 或 `send` 函数，或者使用空的 `calldata`。如果要触发合约的回退函数，可以使用 `call` 函数，并且不指定任何函数签名或参数。
- 例如，下面的代码展示了如何调用合约的回退函数：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract MyContract {
    uint256 public totalReceived;

    // 回退函数
    fallback() external payable {
        totalReceived += msg.value;
    }
}

contract Caller {
    // 调用合约的回退函数
    function callFallback(address payable _contract) public payable {
        // 使用 transfer 或 send 函数发送以太币
        _contract.transfer(msg.value);
        // 或者使用 call 函数，并且不指定任何函数签名或参数
        (bool success, ) = _contract.call{value: msg.value}("");
        require(success, "Call failed");
    }
}
```
回退函数除了用于接收以太币或执行一些默认的逻辑之外，还有一些高级的用法，例如：

- 回退函数可以使用 `receive` 关键字声明，用于专门处理纯以太币转账。这样可以避免与其他函数签名冲突，也可以提高代码的可读性和安全性。`receive` 函数必须使用 `payable` 修饰符，并且不能有参数或返回值。
- 回退函数可以使用 `revert` 关键字抛出异常，用于拒绝不符合条件的消息或转账。这样可以防止合约被滥用或攻击，也可以节省 gas，因为异常会导致交易回滚。
- 回退函数可以使用 `assembly` 关键字编写内联汇编代码，用于直接操作底层的 EVM 指令。这样可以实现一些高级的功能或优化，例如代理合约、元交易、自毁合约等。

例如，下面的合约展示了回退函数的一些高级用法：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract MyContract {
    // 使用 receive 函数处理纯以太币转账
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    // 使用 revert 抛出异常
    fallback() external payable {
        revert("Invalid operation");
    }

    // 使用 assembly 编写内联汇编代码
    function selfDestruct(address payable _recipient) external {
        assembly {
            // 调用 SELFDESTRUCT 指令，销毁合约并发送余额给接收者
            selfdestruct(_recipient)
        }
    }

    // 定义一个事件
    event Received(address sender, uint256 amount);
}
```
实际上，回退函数确实有一些安全风险，如果不注意的话，可能会导致合约被滥用或攻击，或者造成不必要的 gas 消耗。以下是一些常见的回退函数的安全风险和防止方法：

- **回退函数被意外触发**：如果合约收到了不匹配任何其他函数的消息，回退函数就会被执行。这可能是因为调用者输入了错误的函数签名或参数，或者因为合约升级导致接口变化。这样可能会导致合约执行一些不期望的逻辑，或者浪费 gas。为了防止这种情况，可以在回退函数中检查 `msg.data` 的长度，如果不为空，就抛出异常。或者，可以使用 `receive` 函数来专门处理纯以太币转账，避免与其他函数签名冲突。

下面的合约 A 有一个回退函数，用于记录合约收到的以太币数量。合约 B 有一个函数，用于调用合约 A 的某个函数。如果合约 B 调用了合约 A 不存在的函数，那么合约 A 的回退函数就会被触发，导致合约 A 接收了不期望的以太币。

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract A {
    uint256 public totalReceived;

    // 回退函数
    fallback() external payable {
        totalReceived += msg.value;
    }
}

contract B {
    // 调用合约 A 的某个函数
    function callA(address payable _a, bytes memory _data) public payable {
        (bool success, ) = _a.call{value: msg.value}(_data);
        require(success, "Call failed");
    }
}
```

为了防止这种情况，可以在回退函数中检查 `msg.data` 的长度，如果不为空，就抛出异常¹。例如：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract A {
    uint256 public totalReceived;

    // 回退函数
    fallback() external payable {
        // 检查 msg.data 的长度
        require(msg.data.length == 0, "Invalid data");
        totalReceived += msg.value;
    }
}
```

或者，可以使用 `receive` 函数来专门处理纯以太币转账，避免与其他函数签名冲突。例如：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract A {
    uint256 public totalReceived;

    // 使用 receive 函数处理纯以太币转账
    receive() external payable {
        totalReceived += msg.value;
    }

    // 使用 revert 抛出异常
    fallback() external payable {
        revert("Invalid operation");
    }
}
```


- **回退函数被恶意调用**：如果合约的回退函数有一些敏感的逻辑，例如转发消息、触发事件、修改状态等，那么它可能会被恶意调用者利用，以达到一些不良的目的。例如，调用者可以发送一些无效的数据来触发合约的回退函数，从而干扰合约的正常运行。或者，调用者可以发送一些极小的以太币来触发合约的回退函数，从而消耗合约的 gas。为了防止这种情况，可以在回退函数中添加一些权限检查或条件判断，只允许特定的调用者或满足特定的条件才能执行回退函数。或者，可以使用 `revert` 关键字抛出异常，拒绝不符合条件的消息或转账。

下面的合约 C 有一个回退函数，用于转发消息给另一个合约 D。合约 D 有一个函数，用于修改自己的状态变量。如果一个恶意调用者发送了一些无效的数据给合约 C，那么合约 C 的回退函数就会被触发，导致合约 D 的状态变量被修改。

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract C {
    address public target;

    // 构造函数，设置目标地址
    constructor(address _target) {
        target = _target;
    }

    // 回退函数，转发消息给目标地址
    fallback() external payable {
        (bool success, ) = target.call{value: msg.value}(msg.data);
        require(success, "Call failed");
    }
}

contract D {
    uint256 public count;

    // 修改状态变量的函数
    function inc() external returns (uint256) {
        count += 1;
        return count;
    }
}
```

为了防止这种情况，可以在回退函数中添加一些权限检查或条件判断，只允许特定的调用者或满足特定的条件才能执行回退函数。例如：


```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract C {
    address public target;
    address public owner;

    // 构造函数，设置目标地址和所有者地址
    constructor(address _target) {
        target = _target;
        owner = msg.sender;
    }

    // 回退函数，转发消息给目标地址
    fallback() external payable {
        // 检查调用者是否是所有者
        require(msg.sender == owner, "Not owner");
        (bool success, ) = target.call{value: msg.value}(msg.data);
        require(success, "Call failed");
    }
}

contract D {
    uint256 public count;

    // 修改状态变量的函数
    function inc() external returns (uint256) {
        count += 1;
        return count;
    }
}
```

或者，可以使用 `revert` 关键字抛出异常，拒绝不符合条件的消息或转账。例如：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract C {
    address public target;

    // 构造函数，设置目标地址
    constructor(address _target) {
        target = _target;
    }

    // 回退函数，转发消息给目标地址
    fallback() external payable {
        // 拒绝任何消息或转账
        revert("Invalid operation");
    }
}

contract D {
    uint256 public count;

    // 修改状态变量的函数
    function inc() external returns (uint256) {
        count += 1;
        return count;
    }
}
```


- **回退函数被递归调用**：如果合约的回退函数在执行过程中又调用了其他合约，那么它可能会被递归调用，导致栈溢出或 gas 不足等问题。例如，如果合约 A 的回退函数调用了合约 B 的某个函数，而合约 B 的该函数又调用了合约 A 的回退函数，那么就会形成一个死循环²。或者，如果合约 A 的回退函数调用了一个未知的地址（可能是一个恶意合约），那么该地址可能会反过来调用合约 A 的回退函数。为了防止这种情况，可以在回退函数中避免调用其他合约，或者只调用可信的合约。或者，可以使用 `reentrancyGuard` 修饰符来防止重入攻击。

下面的合约 E 有一个回退函数，用于发送以太币给另一个合约 F。合约 F 有一个回退函数，用于发送以太币给合约 E。如果合约 E 或 F 收到了以太币，那么它们的回退函数就会被触发，导致它们之间形成一个死循环。
```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract E {
    address payable public partner;

    // 构造函数，设置合作伙伴地址
    constructor(address payable _partner) {
        partner = _partner;
    }

    // 回退函数，发送以太币给合作伙伴
    fallback() external payable {
        partner.transfer(msg.value);
    }
}

contract F {
    address payable public partner;

    // 构造函数，设置合作伙伴地址
    constructor(address payable _partner) {
        partner = _partner;
    }

    // 回退函数，发送以太币给合作伙伴
    fallback() external payable {
        partner.transfer(msg.value);
    }
}
```

为了防止这种情况，可以在回退函数中避免调用其他合约，或者只调用可信的合约。例如：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract E {
    address payable public partner;

    // 构造函数，设置合作伙伴地址
    constructor(address payable _partner) {
        partner = _partner;
    }

    // 回退函数，发送以太币给合作伙伴
    fallback() external payable {
        // 检查合作伙伴是否是可信的
        require(partner == address(0x1234), "Untrusted partner");
        partner.transfer(msg.value);
    }
}

contract F {
    address payable public partner;

    // 构造函数，设置合作伙伴地址
    constructor(address payable _partner) {
        partner = _partner;
    }

    // 回退函数，发送以太币给合作伙伴
    fallback() external payable {
        // 检查合作伙伴是否是可信的
        require(partner == address(0x5678), "Untrusted partner");
        partner.transfer(msg.value);
    }
}
```

或者，可以使用 `reentrancyGuard` 修饰符来防止重入攻击。例如：

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// 定义一个 reentrancyGuard 修饰符
modifier reentrancyGuard {
    // 使用一个状态变量来标记是否在调用中
    bool private locked;
    // 在执行前检查是否已经锁定
    require(!locked, "Reentrant call");
    // 锁定状态变量
    locked = true;
    // 执行原始逻辑
    _;
    // 解锁状态变量
    locked = false;
}

contract E {
    address payable public partner;

    // 构造函数，设置合作伙伴地址
    constructor(address payable _partner) {
        partner = _partner;
    }

    // 回退函数，发送以太币给合作伙伴
    // 使用 reentrancyGuard 修饰符
    fallback() external payable reentrancyGuard {
        partner.transfer(msg.value);
    }
}

contract F {
    address payable public partner;

    // 构造函数，设置合作伙伴地址
    constructor(address payable _partner) {
        partner = _partner;
    }

    // 回退函数，发送以太币给合作伙伴
    // 使用 reentrancyGuard 修饰符
    fallback() external payable reentrancyGuard {
        partner.transfer(msg.value);
    }
}
```



