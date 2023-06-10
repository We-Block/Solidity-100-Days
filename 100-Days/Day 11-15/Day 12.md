# Solidity的继承

## 什么是继承？

继承是一种面向对象编程的特性，它允许一个合约（子合约）从另一个合约（父合约）继承其属性和方法。这样，子合约可以复用父合约的代码，避免重复编写相同的逻辑，也可以在子合约中添加新的功能或修改父合约的行为。

Solidity支持多重继承，也就是说，一个合约可以从多个合约继承。当一个合约从多个合约继承时，在区块链上只有一个合约被创建，所有基类合约的代码被复制到创建的合约中。这意味着子合约可以访问所有非私有成员，包括内部（internal）函数和状态变量。

## 如何实现继承？

在Solidity中，实现继承的方式是通过使用`is`关键字来指定子合约要继承的父合约。如果要继承多个合约，可以用逗号分隔。例如：

```solidity
// 定义一个父合约A
contract A {
    uint public x = 1;
    function f() public pure returns (uint) {
        return 2;
    }
}

// 定义一个父合约B
contract B {
    uint public y = 3;
    function g() public pure returns (uint) {
        return 4;
    }
}

// 定义一个子合约C，从A和B继承
contract C is A, B {
    // 可以访问A和B的公共成员
    function h() public view returns (uint) {
        return x + y + f() + g();
    }
}
```

在上面的例子中，我们定义了三个合约：A、B和C。C是从A和B继承的子合约，所以它可以访问A和B的公共成员，如状态变量x和y，以及函数f和g。我们在C中定义了一个新的函数h，它返回x、y、f和g的和。

## 如何传递参数给父合约？

如果父合约有构造函数（constructor），那么子合约必须提供父合约构造函数需要的所有参数。有两种方式可以传递参数给父合约：

- 在声明子合约时，在父合约后面用括号包裹参数。例如：

```solidity
// 定义一个父合约D，有一个构造函数需要一个参数
contract D {
    uint public a;
    constructor(uint _a) public {
        a = _a;
    }
}

// 定义一个子合约E，从D继承，并传递参数5给D
contract E is D(5) {
    // 可以访问D的公共成员
    function getA() public view returns (uint) {
        return a;
    }
}
```

- 在定义子合约的构造函数时，用类似修饰器（modifier）的语法传递参数给父合约。例如：

```solidity
// 定义一个父合约F，有一个构造函数需要一个参数
contract F {
    uint public b;
    constructor(uint _b) public {
        b = _b;
    }
}

// 定义一个子合约G，从F继承，并有一个构造函数需要一个参数
contract G is F {
    uint public c;
    constructor(uint _c) public F(_c + 1) {
        // 传递参数_c + 1给F的构造函数
        c = _c;
    }
}
```

在上面的例子中，我们定义了一个子合约G，从F继承，并有一个构造函数需要一个参数_c。我们在G的构造函数中用`F(_c + 1)`的语法传递参数_c + 1给F的构造函数。这样，G可以访问F的公共成员b，并且b的值是_c + 1。

## 如何处理多重继承的冲突？

当一个合约从多个合约继承时，可能会出现一些冲突，例如：

- 多个父合约有同名的函数或变量
- 多个父合约有同名的构造函数
- 多个父合约有同名的事件或修饰器

为了解决这些冲突，Solidity提供了一些规则和语法：

- 如果多个父合约有同名的函数或变量，那么子合约必须显式地指定要使用哪个父合约的成员。这可以通过使用`super`关键字或者父合约的名称来实现。例如：

```solidity
// 定义一个父合约H，有一个同名的函数和变量
contract H {
    uint public x = 5;
    function f() public pure returns (uint) {
        return 6;
    }
}

// 定义一个父合约I，有一个同名的函数和变量
contract I {
    uint public x = 7;
    function f() public pure returns (uint) {
        return 8;
    }
}

// 定义一个子合约J，从H和I继承
contract J is H, I {
    // 如果要访问H或I的x，必须显式地指定
    function getX() public view returns (uint, uint) {
        return (H.x, I.x); // 返回(5, 7)
    }

    // 如果要调用H或I的f，必须显式地指定
    function getF() public view returns (uint, uint) {
        return (H.f(), I.f()); // 返回(6, 8)
    }

    // 如果要重写f，必须使用override关键字，并且可以用super关键字来调用父合约的f
    function f() public pure override(H, I) returns (uint) {
        return super.f() + 1; // 返回9，因为I是最近的父合约，所以super.f()等于I.f()
    }
}
```

- 如果多个父合约有同名的构造函数，那么子合约必须为每个父合约提供参数，并且按照继承顺序排列。例如：

```solidity
// 定义一个父合约K，有一个同名的构造函数
contract K {
    uint public a;
    constructor(uint _a) public {
        a = _a;
    }
}

// 定义一个父合约L，有一个同名的构造函数
contract L {
    uint public b;
    constructor(uint _b) public {
        b = _b;
    }
}

// 定义一个子合约M，从K和L继承，并有一个构造函数需要两个参数
contract M is K, L {
    uint public c;
    constructor(uint _a, uint _b) public K(_a) L(_b) {
        // 为每个父合约提供参数，并且按照继承顺序排列
        c = _a + _b;
    }
}
```

- 如果多个父合约有同名的事件或修饰器，那么子合约可以正常使用它们，不会产生冲突。但是，如果子合约想要重写或扩展它们，必须使用`override`和`virtual`关键字，并且可以用`super`关键字来调用父合约的事件或修饰器。例如：

```solidity
// 定义一个父合约N，有一个同名的事件和修饰器
contract N {
    event Log(uint x);
    modifier check(uint x) {
        require(x > 0, "x must be positive");
        _;
    }
}

// 定义一个父合约O，有一个同名的事件和修饰器
contract O {
    event Log(uint y);
    modifier check(uint y) {
        require(y < 10, "y must be less than 10");
        _;
    }
}

// 定义一个子合约P，从N和O继承，并重写事件和修饰器
contract P is N, O {
    // 重写事件Log，必须使用override关键字，并且可以用super关键字来触发父合约的事件
    event Log(uint x, uint y) override(N, O);
    function emitLog(uint x, uint y) public {
        super.Log(x); // 触发N的事件
        super.Log(y); // 触发O的事件
        emit Log(x, y); // 触发P的事件
    }

    // 重写修饰器check，必须使用override和virtual关键字，并且可以用super关键字来调用父合约的修饰器
    modifier check(uint x, uint y) override(N, O) virtual {
        super.check(x); // 调用N的修饰器
        super.check(y); // 调用O的修饰器
        _;
    }

    // 使用P的修饰器check
    function foo(uint x, uint y) public check(x, y) {
        // do something
    }
}
```

# 不同类别的继承

## 单一继承

单一继承是指一个合约只从一个合约继承。这是最简单的继承方式，也是最容易理解和管理的。例如：

```solidity
// 定义一个父合约A
contract A {
    uint public x = 1;
    function f() public pure returns (uint) {
        return 2;
    }
}

// 定义一个子合约B，从A继承
contract B is A {
    // 可以访问A的公共成员
    function g() public view returns (uint) {
        return x + f();
    }
}
```

在上面的例子中，我们定义了两个合约：A和B。B是从A继承的子合约，所以它可以访问A的公共成员，如状态变量x和函数f。我们在B中定义了一个新的函数g，它返回x和f的和。

## 层次继承

层次继承是指一个合约从另一个合约继承，而后者又从第三个合约继承，依此类推。这样就形成了一个继承层次结构，也称为继承树。例如：

```solidity
// 定义一个父合约C
contract C {
    uint public x = 1;
    function f() public pure returns (uint) {
        return 2;
    }
}

// 定义一个子合约D，从C继承
contract D is C {
    // 可以访问C的公共成员
    function g() public view returns (uint) {
        return x + f();
    }
}

// 定义一个子合约E，从D继承
contract E is D {
    // 可以访问D和C的公共成员
    function h() public view returns (uint) {
        return x + f() + g();
    }
}
```

在上面的例子中，我们定义了三个合约：C、D和E。E是从D继承的子合约，而D又是从C继承的子合约。所以E可以访问D和C的公共成员，如状态变量x和函数f和g。我们在E中定义了一个新的函数h，它返回x、f和g的和。

## 多重继承

多重继承是指一个合约从多个合约继承。这是一种更复杂的继承方式，也是更容易产生冲突和歧义的。例如：

```solidity
// 定义一个父合约F
contract F {
    uint public x = 1;
    function f() public pure returns (uint) {
        return 2;
    }
}

// 定义一个父合约G
contract G {
    uint public y = 3;
    function g() public pure returns (uint) {
        return 4;
    }
}

// 定义一个子合约H，从F和G继承
contract H is F, G {
    // 可以访问F和G的公共成员
    function h() public view returns (uint) {
        return x + y + f() + g();
    }
}
```

在上面的例子中，我们定义了三个合约：F、G和H。H是从F和G继承的子合约，所以它可以访问F和G的公共成员，如状态变量x和y，以及函数f和g。我们在H中定义了一个新的函数h，它返回x、y、f和g的和。

## 菱形继承

菱形继承是指一个合约从两个或多个合约继承，而这些父合约又有一个或多个共同的祖先合约。这样就形成了一个菱形的继承结构，也称为菱形问题（diamond problem）。例如：

```solidity
// 定义一个祖先合约I
contract I {
    uint public x = 1;
    function f() public pure returns (uint) {
        return 2;
    }
}

// 定义一个父合约J，从I继承
contract J is I {
    // 可以访问I的公共成员
    function g() public view returns (uint) {
        return x + f();
    }
}

// 定义一个父合约K，从I继承
contract K is I {
    // 可以访问I的公共成员
    function h() public view returns (uint) {
        return x + f();
    }
}

// 定义一个子合约L，从J和K继承
contract L is J, K {
    // 可以访问J和K的公共成员
    function i() public view returns (uint) {
        return g() + h();
    }
}
```

在上面的例子中，我们定义了四个合约：I、J、K和L。L是从J和K继承的子合约，而J和K又是从I继承的父合约。所以L可以访问J和K的公共成员，如函数g和h。我们在L中定义了一个新的函数i，它返回g和h的和。

菱形继承可能会导致一些冲突和歧义，例如：

- 如果祖先合约有一个函数或变量，那么子合约会从哪个父合约继承它？
- 如果父合约重写了祖先合约的一个函数或变量，那么子合约会使用哪个父合约的版本？
- 如果子合约想要重写或扩展祖先合约或父合约的一个函数或变量，那么它应该如何指定？

为了解决这些问题，Solidity提供了一些规则和语法：

- 如果祖先合约有一个函数或变量，那么子合约会按照继承顺序从最近的父合约继承它。例如，在上面的例子中，L会从K继承I的x和f，而不是从J继承。
- 如果父合约重写了祖先合约的一个函数或变量，那么子合约会使用最近的父合约的版本。例如，在上面的例子中，如果J和K都重写了I的f，那么L会使用K的f，而不是J或I的f。
- 如果子合约想要重写或扩展祖先合约或父合约的一个函数或变量，那么它必须使用`override`关键字，并且可以用`super`关键字来调用父合约或祖先合约的成员。例如，在上面的例子中，如果L想要重写I、J或K的f，它可以这样写：

```solidity
// 定义一个子合约L，从J和K继承，并重写f
contract L is J, K {
    // 重写f，必须使用override关键字，并且可以用super关键字来调用父合约或祖先合约的f
    function f() public pure override(I, J, K) returns (uint) {
        return super.f() + 1; // 返回3，因为K是最近的父合约，所以super.f()等于K.f()
    }
}
```

# 关键字

## override关键字

`override`关键字是用来标记一个函数或变量，表示它重写了父合约或祖先合约的同名成员。使用`override`关键字可以提高代码的可读性和可靠性，也可以避免意外地覆盖父合约或祖先合约的成员。例如：

```solidity
// 定义一个父合约Q
contract Q {
    uint public x = 1;
    function f() public pure returns (uint) {
        return 2;
    }
}

// 定义一个子合约R，从Q继承，并重写x和f
contract R is Q {
    // 重写x，必须使用override关键字
    uint public override x = 3;
    // 重写f，必须使用override关键字
    function f() public pure override returns (uint) {
        return 4;
    }
}
```

在上面的例子中，我们定义了两个合约：Q和R。R是从Q继承的子合约，并重写了Q的x和f。我们在R中使用了`override`关键字来标记x和f，表示它们重写了Q的同名成员。

如果一个合约从多个合约继承，而这些父合约或祖先合约都有同名的函数或变量，那么子合约必须在`override`关键字后面用括号列出所有要重写的合约。例如：

```solidity
// 定义一个祖先合约S
contract S {
    uint public x = 1;
    function f() public pure returns (uint) {
        return 2;
    }
}

// 定义一个父合约T，从S继承，并重写x和f
contract T is S {
    // 重写x，必须使用override关键字，并列出S
    uint public override(S) x = 3;
    // 重写f，必须使用override关键字，并列出S
    function f() public pure override(S) returns (uint) {
        return 4;
    }
}

// 定义一个父合约U，从S继承，并重写x和f
contract U is S {
    // 重写x，必须使用override关键字，并列出S
    uint public override(S) x = 5;
    // 重写f，必须使用override关键字，并列出S
    function f() public pure override(S) returns (uint) {
        return 6;
    }
}

// 定义一个子合约V，从T和U继承，并重写x和f
contract V is T, U {
    // 重写x，必须使用override关键字，并列出T和U
    uint public override(T, U) x = 7;
    // 重写f，必须使用override关键字，并列出T和U
    function f() public pure override(T, U) returns (uint) {
        return 8;
    }
}
```

在上面的例子中，我们定义了四个合约：S、T、U和V。V是从T和U继承的子合约，而T和U又是从S继承的父合约。所以V要重写S、T和U的x和f。我们在V中使用了`override(T, U)`的语法来标记x和f，表示它们重写了T和U的同名成员。

## virtual关键字

`virtual`关键字是用来标记一个函数或变量，表示它可以被子合约或后代合约重写。使用`virtual`关键字可以提高代码的灵活性和可扩展性，也可以让子合约或后代合约定制自己的逻辑或行为。例如：

```solidity
// 定义一个父合约W
contract W {
    uint public x = 1;
    // 标记f为virtual，表示它可以被子合约或后代合约重写
    function f() public virtual pure returns (uint) {
        return 2;
    }
}

// 定义一个子合约X，从W继承，并重写f
contract X is W {
    // 重写f，必须使用override关键字
    function f() public override pure returns (uint) {
        return 3;
    }
}

// 定义一个后代合约Y，从X继承，并重写f
contract Y is X {
    // 重写f，必须使用override关键字
    function f() public override pure returns (uint) {
        return 4;
    }
}
```

在上面的例子中，我们定义了三个合约：W、X和Y。Y是从X继承的后代合约，而X又是从W继承的子合约。所以Y可以重写W和X的f。我们在W中使用了`virtual`关键字来标记f，表示它可以被子合约或后代合约重写。我们在X和Y中使用了`override`关键字来标记f，表示它们重写了父合约或祖先合约的f。

注意，如果一个函数或变量已经被标记为`virtual`，那么它的子合约或后代合约不需要再次标记为`virtual`，除非它们想要允许更深层次的重写。例如，在上面的例子中，X和Y不需要再次标记f为`virtual`，除非它们想要允许Z等更深层次的后代合约重写f。

## super关键字

`super`关键字是用来调用父合约或祖先合约的函数或变量。使用`super`关键字可以保持继承链的完整性和一致性，也可以避免意外地覆盖父合约或祖先合约的逻辑或行为。例如：

```solidity
// 定义一个父合约Z
contract Z {
    uint public x = 1;
    function f() public pure returns (uint) {
        return 2;
    }
}

// 定义一个子合约A1，从Z继承，并扩展f
contract A1 is Z {
    // 扩展f，必须使用override和virtual关键字，并且可以用super关键字来调用Z的f
    function f() public virtual override pure returns (uint) {
        return super.f() + 1; // 返回3
    }
}

// 定义一个后代合约B1，从A1继承，并扩展f
contract B1 is A1 {
    // 扩展f，必须使用override关键字，并且可以用super关键字来调用A1的f
    function f() public override pure returns (uint) {
        return super.f() + 1; // 返回4
    }
}
```

在上面的例子中，我们定义了三个合约：Z、A1和B1。B1是从A1继承的后代合约，而A1又是从Z继承的子合约。所以B1可以扩展Z和A1的f。我们在A1和B1中使用了`super`关键字来调用父合约或祖先合约的f，并且在返回值上加了1。

- 当一个合约从多个合约继承时，`super`关键字会按照继承顺序从最近的父合约开始调用，直到最远的祖先合约结束。这样就形成了一个`super`调用链，也称为C3线性化（C3 linearization）。例如：

```solidity
// 定义一个祖先合约C1
contract C1 {
    function f() public pure returns (uint) {
        return 1;
    }
}

// 定义一个父合约D1，从C1继承，并扩展f
contract D1 is C1 {
    function f() public virtual override pure returns (uint) {
        return super.f() + 2; // 返回3
    }
}

// 定义一个父合约E1，从C1继承，并扩展f
contract E1 is C1 {
    function f() public virtual override pure returns (uint) {
        return super.f() + 4; // 返回5
    }
}

// 定义一个子合约F1，从D1和E1继承，并扩展f
contract F1 is D1, E1 {
    function f() public override pure returns (uint) {
        return super.f() + 8; // 返回16
    }
}
```

在上面的例子中，我们定义了四个合约：C1、D1、E1和F1。F1是从D1和E1继承的子合约，而D1和E1又是从C1继承的父合约。所以F1可以扩展C1、D1和E1的f。我们在F1中使用了`super`关键字来调用父合约或祖先合约的f，并且在返回值上加了8。

当我们调用F1的f时，它会按照继承顺序从最近的父合约开始调用，直到最远的祖先合约结束。也就是说，它会先调用E1的f，然后调用D1的f，最后调用C1的f。这样就形成了一个`super`调用链：F1 -> E1 -> D1 -> C1。我们可以用下面的公式来计算F1的f的返回值：

```solidity
F1.f() = E1.f() + 8
       = (D1.f() + 4) + 8
       = ((C1.f() + 2) + 4) + 8
       = (((1) + 2) + 4) + 8
       = 16
```

## 总结

`override`关键字是用来标记一个函数或变量，表示它重写了父合约或祖先合约的同名成员。使用`override`关键字可以提高代码的可读性和可靠性，也可以避免意外地覆盖父合约或祖先合约的成员。

`virtual`关键字是用来标记一个函数或变量，表示它可以被子合约或后代合约重写。使用`virtual`关键字可以提高代码的灵活性和可扩展性，也可以让子合约或后代合约定制自己的逻辑或行为。

`super`关键字是用来调用父合约或祖先合约的函数或变量。使用`super`关键字可以保持继承链的完整性和一致性，也可以避免意外地覆盖父合约或祖先合约的逻辑或行为。

### 风险

Solidity的继承功能有以下一些风险：

- 继承可能导致合约的代码变得复杂和难以维护，特别是当有多重继承或者同名的成员时，需要注意解决冲突和避免歧义。
- 继承可能增加合约的部署和执行的成本，因为继承会导致合约的字节码变得更大，而这会消耗更多的gas。
- 继承可能引入安全漏洞，如果父合约的代码有缺陷或者被恶意修改，那么子合约也会受到影响。因此，需要谨慎地选择要继承的合约，并且定期检查其源码和字节码。

因此，在使用继承功能时，需要权衡其优势和劣势，并且遵循一些最佳实践，例如：

- 尽量使用单一继承或者层次继承，避免使用多重继承或者菱形继承，以减少复杂度和冲突。
- 尽量使用接口（interface）或者抽象合约（abstract contract）来定义父合约的规范，而不是实现具体的逻辑，以减少代码的重复和冗余。
- 尽量使用`override`和`virtual`关键字来明确地标记要重写或扩展的成员，以提高代码的可读性和可靠性。
- 尽量使用`super`关键字来调用父合约的成员，以保持继承链的完整性和一致性。