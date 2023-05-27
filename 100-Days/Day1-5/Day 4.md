# Solidity基础语法 - 函数

## 什么是函数？

函数是一段可以被重复调用的代码块，它可以接收一些输入参数，执行一些操作，并返回一些输出结果。函数可以使代码更简洁、更模块化、更易于复用和维护。

在Solidity中，函数是合约的基本组成部分，每个合约至少有一个函数，即构造函数。函数可以定义在合约内部，也可以定义在合约外部，作为库函数或接口函数。

## 如何定义函数？

函数的定义由以下几个部分组成：

- 函数名：用来标识和调用函数的标识符，必须以字母或下划线开头，不能与关键字或已有的变量名冲突。
- 参数列表：用括号包围的一组变量声明，表示函数接收的输入参数，每个参数由类型和名称组成，多个参数之间用逗号分隔。如果没有参数，可以留空或写一个空括号。
- 返回值列表：用returns关键字后跟括号包围的一组变量声明，表示函数返回的输出结果，每个返回值由类型和名称（可选）组成，多个返回值之间用逗号分隔。如果没有返回值，可以省略这部分。
- 可见性修饰符：用来指定函数在合约内部和外部的可访问性，有public、private、internal和external四种选项。如果没有指定，默认为public。
- 函数修改器：用来对函数的行为进行限制或检查，有很多内置的或自定义的修改器可供选择，如pure、view、payable、require等。多个修改器之间用空格分隔。如果没有修改器，可以省略这部分。
- 函数体：用花括号包围的一段代码语句，表示函数要执行的具体操作。如果是抽象函数或接口函数，则没有函数体。

下面是一个简单的函数定义的例子：

```solidity
// 定义一个求两个数最大值的函数
function max(uint a, uint b) public pure returns (uint) {
    // 如果a大于b，则返回a，否则返回b
    if (a > b) {
        return a;
    } else {
        return b;
    }
}
```

## 如何调用函数？

函数的调用由以下几个部分组成：

- 函数名：要调用的函数的标识符。
- 参数列表：用括号包围的一组表达式或变量，表示要传递给函数的实际参数值，每个参数之间用逗号分隔。如果没有参数，可以留空或写一个空括号。
- 返回值接收：如果函数有返回值，则可以用一个或多个变量来接收返回值，变量之间用逗号分隔，并用等号赋值给函数调用表达式。

下面是一个简单的函数调用的例子：

```solidity
// 声明两个无符号整数变量x和y，并赋值为10和20
uint x = 10;
uint y = 20;

// 调用max函数，并将返回值赋值给z
uint z = max(x, y);

// 打印z的值
console.log(z); // 输出20
```

## 函数的可见性

函数的可见性修饰符决定了函数在合约内部和外部的可访问性。有以下四种选项：

- public：表示函数可以在合约内部和外部被任何人调用。这是默认的可见性修饰符。
- private：表示函数只能在合约内部被同一个合约调用，不能被其他合约或外部账户调用。
- internal：表示函数只能在合约内部被同一个合约或继承自该合约的子合约调用，不能被其他合约或外部账户调用。
- external：表示函数只能在合约外部被其他合约或外部账户调用，不能在合约内部被同一个合约调用。

下面是一个示例合约，展示了不同可见性修饰符的效果：

```solidity
// 声明一个名为Visibility的合约
contract Visibility {

    // 定义一个public类型的变量a，并赋值为1
    uint public a = 1;

    // 定义一个private类型的变量b，并赋值为2
    uint private b = 2;

    // 定义一个internal类型的变量c，并赋值为3
    uint internal c = 3;

    // 定义一个external类型的变量d，并赋值为4
    uint external d = 4;

    // 定义一个public类型的无参无返回值的函数f1
    function f1() public {
        // 在f1中可以访问a、b、c、d
        console.log(a); // 输出1
        console.log(b); // 输出2
        console.log(c); // 输出3
        console.log(d); // 输出4
    }

    // 定义一个private类型的无参无返回值的函数f2
    function f2() private {
        // 在f2中可以访问a、b、c、d
        console.log(a); // 输出1
        console.log(b); // 输出2
        console.log(c); // 输出3
        console.log(d); // 输出4
    }

    // 定义一个internal类型的无参无返回值的函数f3
    function f3() internal {
        // 在f3中可以访问a、b、c、d
        console.log(a); // 输出1
        console.log(b); // 输出2
        console.log(c); // 输出3
        console.log(d); // 输出4
    }

    // 定义一个external类型的无参无返回值的函数f4
    function f4() external {
        // 在f4中可以访问a、d，但不能访问b、c
        console.log(a); // 输出1
        console.log(d); // 输出4

        // 下面两行会报错，因为b和c是private和internal类型，在external类型的函数中不能访问

        // console.log(b);
        // console.log(c);
    }
}

// 声明一个名为ChildVisibility的合约，继承自Visibility合约
contract ChildVisibility is Visibility {

    // 定义一个public类型的无参无返回值的函数f5
    function f5() public {
        // 在f5中可以访问a、c、d，但不能访问b
        console.log(a); // 输出1
        console.log(c); // 输出3
        console.log(d); // 输出4

        // 下面一行会报错，因为b是private类型，在子合约中不能访问

        // console.log(b);
    }

    // 定义一个external类型的无参无返回值的函数f6
    function f6() external {
        // 在f6中可以访问a、d，但不能访问b、c
        console.log(a); // 输出1
        console.log(d); // 输出4

        // 下面两行会报错，因为b和c是private和internal类型，在external类型的函数中不能访问

        // console.log(b);
        // console.log(c);
    }
}


// 声明一个名为OtherContract的合约
contract OtherContract {

    // 创建一个Visibility合约实例vis，并传入该合约地址作为构造参数（假设已知）
    Visibility vis = Visibility(address);

    // 创建一个ChildVisibility合约实例child，并传入该合约地址作为构造参数（假设已知）
    ChildVisibility child = ChildVisibility(address);

    // 定义一个public类型的无参无返回值的函数f7
    function f7() public {
        // 在f7中可以调用vis和child的public和external类型的函数，但不能调用private和internal类型的函数

        // 调用vis的public类型的函数f1
        vis.f1(); // 正常执行

        // 调用vis的external类型的函数f4
        vis.f4(); // 正常执行

        // 下面两行会报错，因为f2和f3是private和internal类型，在其他合约中不能调用

        // vis.f2();
        // vis.f3();

        // 调用child的public类型的函数f5
        child.f5(); // 正常执行

        // 调用child的external类型的函数f6
        child.f6(); // 正常执行

        // 下面一行会报错，因为f2是private类型，在其他合约中不能调用

        // child.f2();
    }
}

```

**注：**

Solidity本身没有提供console.log的功能，但是可以通过一些第三方库或工具来实现。例如：

- Hardhat提供了一个名为hardhat/console.sol的库，可以在合约中导入并使用console.log函数来打印日志。这个库可以与Hardhat EVM或其他测试框架一起使用，也可以在其他网络中运行，但是会产生gas费用。
- Truffle提供了一个名为truffle/Console.sol的库，也可以在合约中导入并使用console.log函数来打印日志。这个库只能与Truffle的测试框架一起使用，不能在其他网络中运行。
- Remix IDE支持Hardhat EVM的console.log功能，可以在Remix中直接打印日志。

下面是一个使用Hardhat的console.log的例子：

```solidity
// 导入hardhat/console.sol库
import "hardhat/console.sol";

// 声明一个名为ConsoleLogContract的合约
contract ConsoleLogContract {

    // 定义一个public类型的无参无返回值的函数f1
    function f1() public {
        // 在f1中使用console.log函数打印一些信息
        console.log("This is f1");
    }
}
```

## 函数修改器

函数修改器是一种特殊的函数，用来对函数的行为进行限制或检查。函数修改器可以定义在合约内部，也可以定义在合约外部，作为库函数或接口函数。函数修改器可以有参数，也可以没有参数。函数修改器可以有多个，用空格分隔。

函数修改器的定义由以下几个部分组成：

- modifier关键字：用来声明一个函数修改器。
- 修改器名：用来标识和调用修改器的标识符，必须以字母或下划线开头，不能与关键字或已有的变量名冲突。
- 参数列表：用括号包围的一组变量声明，表示修改器接收的输入参数，每个参数由类型和名称组成，多个参数之间用逗号分隔。如果没有参数，可以留空或写一个空括号。
- 修改器体：用花括号包围的一段代码语句，表示修改器要执行的具体操作。修改器体中必须包含一个下划线_，表示被修饰的函数要执行的位置。

下面是一个简单的修改器定义的例子：

```solidity
// 定义一个名为OwnerOnly的修改器，接收一个地址类型的参数owner
modifier OwnerOnly(address owner) {
    // 检查当前调用者是否是owner，如果不是，则抛出异常
    require(msg.sender == owner, "Only owner can call this function");
    // 如果是，则继续执行被修饰的函数
    _;
}

```

要使用一个修改器修饰一个函数，只需要在函数定义中，在可见性修饰符后面加上修改器名，并传入相应的参数（如果有）。例如：

```solidity
// 声明一个名为OwnerContract的合约
contract OwnerContract {

    // 定义一个public类型的地址变量owner，并在构造函数中赋值为当前部署者
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // 定义一个public类型的无参无返回值的函数f1，并使用OwnerOnly修改器修饰
    function f1() public OwnerOnly(owner) {
        // 在f1中可以执行任何操作
        console.log("This is f1");
    }
}

```

这样，只有owner才能调用f1函数，其他人调用会失败。

除了自定义修改器外，Solidity还提供了一些内置的修改器，如pure、view、payable等。下面介绍这些内置修改器的含义和作用。

## pure函数

pure是一个内置的函数修改器，表示该函数不会读取或修改合约状态或外部环境（如全局变量、区块信息、事件等），只依赖于输入参数和返回值。pure函数通常用于一些纯计算或逻辑判断等操作。

使用pure修饰符可以提高代码可读性和安全性，也可以节省一些gas费用。如果在pure函数中尝试读取或修改状态或外部环境，则会报错。

下面是一个使用pure修饰符的例子：

```solidity
// 定义一个求两个数最大值的pure函数
function max(uint a, uint b) public pure returns (uint) {
    if (a > b) {
        return a;
    } else {
        return b;
    }
}

```

## constant、view函数

constant和view是两个等价的内置函数修改器，表示该函数不会修改合约状态或外部环境（如全局变量、区块信息、事件等），只会读取它们。constant和view函数通常用于一些查询或检查等操作。

使用constant或view修饰符可以提高代码可读性和安全性，也可以节省一些gas费用。如果在constant或view函数中尝试修改状态或外部环境，则会报错。

下面是一个使用constant修饰符（也可以换成view）的例子：

```solidity
// 声明一个名为CounterContract的合约
contract CounterContract {

    // 定义一个public类型的无符号整数变量count，并赋值为0
    uint public count = 0;

    // 定义一个public类型的无参无返回值的函数increment，并使用constant修饰符修饰
    function increment() public constant {
        // 在increment中尝试增加count的值
        count++;

        // 上面一行会报错，因为count是合约状态变量，在constant修饰符修饰下不能被修改
    }

    // 定义一个public类型无参有返回值（uint） 的函数getCount，并使用constant修饰符修饰
    function getCount() public constant returns (uint) {
        // 在getCount中返回count 的值
        return count;

        // 这里不会报错，因为count只是被读取而不被修改，在constant修饰符下允许这样做
    }
}

```

## payable函数

payable是一个内置的函数修改器，表示该函数可以接收以太币（Ether）作为支付。payable函数通常用于一些涉及转账或赞助等操作。

使用payable修饰符可以使合约具有接收以太币并处理相关逻辑的能力。如果没有payable修饰符，则任何向该合约发送以太币都会失败

下面是一个使用payable修饰符的例子：

```solidity
// 声明一个名为DonationContract的合约
contract DonationContract {

    // 定义一个public类型的地址变量owner，并在构造函数中赋值为当前部署者
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    // 定义一个public类型的无参无返回值的函数donate，并使用payable修饰符修饰
    function donate() public payable {
        // 在donate中可以使用msg.value来获取发送者发送的以太币数量（单位为wei）
        console.log("Thank you for your donation of", msg.value, "wei");

        // 在donate中可以使用address(this).balance来获取合约当前的以太币余额（单位为wei）
        console.log("The contract balance is now", address(this).balance, "wei");
    }

    // 定义一个public类型的无参无返回值的函数withdraw，并使用OwnerOnly修改器修饰
    function withdraw() public OwnerOnly(owner) {
        // 在withdraw中可以使用address payable类型的变量来接收以太币
        address payable recipient = payable(owner);

        // 在withdraw中可以使用transfer函数来向指定地址发送以太币（单位为wei）
        recipient.transfer(address(this).balance);

        // 在withdraw中可以打印一些信息
        console.log("The owner has withdrawn all the funds");
    }
}
```

## 回退函数

回退函数是一种特殊的函数，它没有名字，没有参数，没有返回值，也没有可见性修饰符。回退函数只能有一个，且必须使用external修饰符修饰。回退函数可以有payable修饰符，也可以没有。

回退函数的作用是在合约收到以太币或者没有匹配到任何其他函数时，自动执行。回退函数通常用于处理一些异常情况或默认行为。

下面是一个使用回退函数的例子：

```solidity
// 声明一个名为FallbackContract的合约
contract FallbackContract {

    // 定义一个public类型的事件FallbackTriggered，用于记录回退函数被触发时的信息
    event FallbackTriggered(address sender, uint value, bytes data);

    // 定义一个external payable类型的无名无参无返回值的函数，即回退函数
    function () external payable {
        // 在回退函数中可以使用msg.sender、msg.value和msg.data来获取发送者地址、发送金额和发送数据
        console.log("Fallback function triggered");

        // 在回退函数中可以触发FallbackTriggered事件，并传入相应的参数
        emit FallbackTriggered(msg.sender, msg.value, msg.data);
    }
}
```

## 构造函数

构造函数是一种特殊的函数，它用来初始化合约状态。构造函数只能有一个，且必须与合约名相同。构造函数可以有参数，也可以没有参数。构造函数可以有可见性修饰符，也可以没有可见性修饰符。构造函数可以有payable修饰符，也可以没有payable修饰符。

构造函数的作用是在合约部署时，自动执行一次，并且只执行一次。构造函数通常用于设置一些初始值或条件。

下面是一个使用构造函数的例子：

```solidity
// 声明一个名为GreeterContract的合约
contract GreeterContract {

    // 定义一个public类型的字符串变量greeting，并在构造函数中赋值为"Hello"
    string public greeting;

    constructor() {
        greeting = "Hello";
    }

    // 定义一个public类型的无参有返回值（string） 的函数getGreeting，并使用view修饰符修饰
    function getGreeting() public view returns (string) {
        // 在getGreeting中返回greeting 的值
        return greeting;
    }
}
```

## 函数参数

函数参数是指在定义或调用函数时，传递给函数的输入值。函数参数分为形式参数和实际参数两种。

形式参数是指在定义函数时，声明在参数列表中的变量，表示该函数需要接收什么样的输入。形式参数由类型和名称组成，多个形式参数之间用逗号分隔。

实际参数是指在调用函数时，传递给参数列表中对应位置的表达式或变量，表示该次调用要传递什么样的具体值。实际参数必须与形式参数类型匹配或兼容，多个实际参数之间用逗号分隔。

下面是一个关于函数参数的例子：

```solidity
// 定义一个求两个数最大值的pure函数
function max(uint a, uint b) public pure returns (uint) {
    if (a > b) {
        return a;
    } else {
        return b;
    }
}

// 声明两个无符号整数变量x和y，并赋值为10和20
uint x = 10;
uint y = 20;

// 调用max函数，并将返回值赋值给z
uint z = max(x, y);

// 打印z的值
console.log(z); // 输出20

// 在这个例子中：
// a和b是形式参数，它们表示max函数需要接收两个uint类型的输入。
// x和y是实际参数，它们表示这次调用要传递给max函数的具体值。
// z是返回值接收变量，它表示要接收max函数返回的结果。
```

## 抽象函数

抽象函数是一种特殊的函数，它只有声明而没有定义。抽象函数通常用于定义接口或抽象合约中，表示该合约需要被其他合约实现或继承。

抽象函数与普通函数相比，只有以下几点不同：

- 抽象函数没有可见性修饰符，默认为external。
- 抽象函数没有payable修饰符。
- 抽象函抽象函数没有函数体，只有一个分号结束。

下面是一个使用抽象函数的例子：

```solidity
// 声明一个名为ERC20的接口
interface ERC20 {

    // 定义一个抽象函数totalSupply，返回uint类型的值
    function totalSupply() external returns (uint);

    // 定义一个抽象函数balanceOf，接收一个address类型的参数owner，返回uint类型的值
    function balanceOf(address owner) external returns (uint);

    // 定义一个抽象函数transfer，接收两个address类型的参数to和from，和一个uint类型的参数value，返回bool类型的值
    function transfer(address to, address from, uint value) external returns (bool);

    // 定义一个抽象函数approve，接收两个address类型的参数spender和owner，和一个uint类型的参数value，返回bool类型的值
    function approve(address spender, address owner, uint value) external returns (bool);

    // 定义一个抽象函数allowance，接收两个address类型的参数owner和spender，返回uint类型的值
    function allowance(address owner, address spender) external returns (uint);
}

// 声明一个名为MyToken的合约，实现ERC20接口
contract MyToken is ERC20 {

    // 在MyToken合约中，需要定义每个抽象函数的具体实现逻辑

    // 定义一个private类型的映射变量balances，用于记录每个地址的代币余额
    mapping(address => uint) private balances;

    // 定义一个private类型的映射变量allowances，用于记录每个地址允许其他地址花费的代币数量
    mapping(address => mapping(address => uint)) private allowances;

    // 定义一个private类型的无符号整数变量totalSupply，用于记录代币总量
    uint private totalSupply;

    // 定义一个public payable类型的构造函数，并接收一个uint类型的参数initialSupply，表示初始代币数量
    constructor(uint initialSupply) public payable {
        // 在构造函数中，将totalSupply赋值为initialSupply
        totalSupply = initialSupply;

        // 在构造函数中，将部署者地址的代币余额赋值为totalSupply
        balances[msg.sender] = totalSupply;
    }

    // 实现totalSupply函数，返回totalSupply变量的值
    function totalSupply() external override returns (uint) {
        return totalSupply;
    }

    // 实现balanceOf函数，返回指定地址的代币余额
    function balanceOf(address owner) external override returns (uint) {
        return balances[owner];
    }

    // 实现transfer函数，从from地址向to地址转移value数量的代币，并返回是否成功
    function transfer(address to, address from, uint value) external override returns (bool) {
        // 检查from地址的代币余额是否大于等于value
        require(balances[from] >= value, "Insufficient balance");

        // 检查to地址不是零地址
        require(to != address(0), "Invalid address");

        // 检查转移后不会发生溢出
        require(balances[to] + value >= balances[to], "Overflow detected");

        // 从from地址减去value数量的代币
        balances[from] -= value;

        // 向to地址增加value数量的代币
        balances[to] += value;

        // 返回true表示成功
        return true;
    }

    // 实现approve函数，允许spender地址从owner地址花费value数量的代币，并返回是否成功
    function approve(address spender, address owner, uint value) external override returns (bool) {
        // 检查spender地址不是零地址
        require(spender != address(0), "Invalid address");

        // 将owner地址对spender地址的允许额度设为value
        allowances[owner][spender] = value;

        // 返回true表示成功
        return true;
    }

    // 实现allowance函数，返回owner地址允许spender地址花费的代币数量
    function allowance(address owner, address spender) external override returns (uint) {
        return allowances[owner][spender];
    }
}
```

## 数学和加密函数

Solidity提供了一些内置的全局函数，用于进行一些数学和加密相关的操作。这些函数可以在任何合约或函数中直接调用，不需要导入或继承任何库或合约。下面介绍一些常用的数学和加密函数。

### 数学函数

- addmod：计算两个无符号整数相加后对另一个无符号整数取模的结果。例如：addmod(3, 5, 7) = (3 + 5) % 7 = 1。
- mulmod：计算两个无符号整数相乘后对另一个无符号整数取模的结果。例如：mulmod(3, 5, 7) = (3 * 5) % 7 = 1。
- keccak256：计算任意长度字节序列（bytes）或固定长度字节数组（bytes1 ~ bytes32） 的Keccak-256哈希值，并返回一个bytes32类型的结果。例如：keccak256("Hello") = 0x1840c62d...。
- sha256：计算任意长度字节序列（bytes）或固定长度字节数组（bytes1 ~ bytes32） 的SHA-256哈希值，并返回一个bytes32类型的结果。例如：sha256("Hello") = 0x185f8db3...。
- ripemd160：计算任意长度字节序列（bytes）或固定长度字节数组（bytes1 ~ bytes32） 的RIPEMD-160哈希值，并返回一个bytes20类型的结果。例如：ripemd160("Hello") = 0x108f07b8...。
- ecrecover：根据给定的消息哈希、签名参数和签名者公钥恢复签名者地址，并返回一个address类型的结果。如果恢复失败，则返回零地址。例如：ecrecover(hash, v, r, s) = 0x1234...。

### 其他函数

- blockhash：根据给定区块号获取该区块头部哈希值，并返回一个bytes32类型的结果。如果区块号超出最近256个区块，则返回零哈希。例如：blockhash(100) = 0x1234...。
- gasleft：获取当前交易剩余可用gas量，并返回一个uint256类型的结果。例如：gasleft() = 100000。
- selfdestruct：销毁当前合约，并将合约余额发送给指定地址。这个操作会消耗较少gas，并且可以释放一些存储空间。例如：selfdestruct(recipient)。
- revert：终止当前交易，并恢复所有状态改变和以太币转移。这个操作会消耗所有剩余gas，并且可以传递一些错误信息。例如：revert("Invalid operation")。
- assert：检查给定条件是否为真，如果为假，则终止当前交易，并恢复所有状态改变和以太币转移。这个操作会消耗所有剩余gas，并且不会传递任何错误信息。assert通常用于检查内部错误或不可能发生的情况。例如：assert(x > 0)。
- require：检查给定条件是否为真，如果为假，则终止当前交易，并恢复所有状态改变和以太币转移。这个操作会消耗较少gas，并且可以传递一些错误信息。require通常用于检查用户输入或外部条件是否满足要求。例如：require(msg.value > 0, "No payment received")。