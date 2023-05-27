# Solidity中的事件

## 什么是事件

事件是以太坊虚拟机 (EVM)日志基础设施提供的一个便利接口。当被发送事件（调用）时，会触发参数存储到交易的日志中（一种区块链上的特殊数据结构）。这些日志与合约的地址关联，并记录到区块链中。

事件可以用来在智能合约中记录一些重要的信息，比如状态变化、用户操作、错误提示等。事件也可以用来在DApp中与智能合约交互，比如监听事件、更新界面、调用函数等。

## 如何定义和触发事件

在Solidity代码中，使用`event`关键字来定义一个事件，如：

```solidity
event EventName (address bidder, uint amount);
```

这个用法和定义函数式一样的，并且事件在合约中同样可以被继承。

触发一个事件使用`emit` (说明，之前的版本里并不需要使用emit)，如：

```solidity
emit EventName (msg.sender, msg.value);
```

触发事件可以在任何函数中调用，如：

```solidity
function testEvent () public {
  // 触发一个事件
  emit EventName (msg.sender, msg.value);
}
```

## 如何监听和过滤事件

监听事件是指在DApp中使用Web3.js或其他库来订阅合约中发生的特定事件，并执行相应的回调函数。

过滤事件是指在监听事件时，可以指定一些条件来筛选出感兴趣的事件，比如时间范围、参数值等。

下面是一个简单的例子，展示了如何使用Web3.js监听和过滤一个名为`Instructor`的事件：

```javascript
// 获取合约实例
var infoContract = web3.eth.contract(ABI_INFO);
var info = infoContract.at('CONTRACT_ADDRESS');

// 定义一个变量引用事件
var instructorEvent = info.Instructor();

// 使用.watch()方法来添加一个回调函数
instructorEvent.watch(function(error, result) {
  if (!error) {
    // 在回调函数中可以访问result对象，包含了事件的相关信息
    console.log(result.args.name + ' (' + result.args.age + ' years old)');
  } else {
    console.log(error);
  }
});

// 使用.stopWatching()方法来取消订阅
instructorEvent.stopWatching();

// 使用.get()方法来获取过去发生的事件
instructorEvent.get(function(error, result) {
  if (!error) {
    // 在回调函数中可以遍历result数组，包含了所有匹配的事件
    for (var i = 0; i < result.length; i++) {
      console.log(result[i].args.name + ' (' + result[i].args.age + ' years old)');
    }
  } else {
    console.log(error);
  }
});

// 在.watch()或.get()方法中可以传入一个过滤器对象，指定一些条件
instructorEvent({name: "Alice"}, {fromBlock: 0, toBlock: 'latest'}).watch(function(error, result) {
  if (!error) {
    // 在回调函数中只会收到name为Alice的事件
    console.log(result.args.name + ' (' + result.args.age + ' years old)');
  } else {
    console.log(error);
  }
});
```

## Event的存储和消耗

Event的参数会被存储到交易的日志中，这是一种区块链上的特殊数据结构，它不占用链上的存储空间，也不会影响合约的状态。因此，Event相比于其他方式来记录信息，比如使用变量或映射，是一种更节省资源和成本的方法。

Event的消耗主要体现在触发事件时所需的gas费用，这个费用取决于事件的参数个数、类型和大小。根据以太坊官方文档，事件的gas费用由以下几部分组成：

- 一个固定的基础费用，为375 gas
- 每个参数（主题）的费用，为375 gas
- 每个字节（数据）的费用，为8 gas
- 内存扩展的费用，为3 gas

因此，可以根据以下公式来计算事件的gas费用：

```text
gas = 375 + 375 * n + 8 * m + 3 * k
```

其中，n是参数（主题）的个数，m是数据的字节数，k是内存扩展的字节数。

举个例子，如果一个事件有两个参数（主题），分别是一个地址和一个uint256类型，以及200字节的数据，那么它的gas费用大约是：

```text
gas = 375 + 375 * 2 + 8 * 200 + 3 * 200
    = 3375 gas
```

## Event的高阶用法

除了基本的定义、触发和监听事件之外，还有一些高阶的用法可以让事件更加强大和灵活。这里介绍两种常见的高阶用法：匿名事件和索引参数。

### 匿名事件

匿名事件是指在定义事件时，在event关键字后面加上`anonymous`修饰符。例如：

```solidity
event AnonymousEvent(address bidder, uint amount) anonymous;
```

匿名事件与普通事件的区别在于，匿名事件不会把事件签名作为第一个主题存储到日志中。这样可以节省一些gas费用，也可以提高一些隐私性。但是，匿名事件也有一些缺点，比如无法通过事件签名来过滤或识别事件。

### 索引参数

索引参数是指在定义事件时，在参数前面加上`indexed`修饰符。例如：

```solidity
event IndexedEvent(address indexed bidder, uint amount);
```

索引参数与普通参数的区别在于，索引参数会被存储到日志中作为主题。这样可以方便地通过主题来过滤或搜索事件。但是，索引参数也有一些限制，比如最多只能有三个索引参数，而且数组和结构体类型不能被索引。