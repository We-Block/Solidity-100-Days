# 理解区块链Gas和交易成本

## 什么是Gas？

Gas是指在区块链网络上执行特定操作所需的计算工作量。由于每笔区块链交易都需要计算资源才能执行，每笔交易都需要付费。在这个方面上，Gas是指在区块链成功进行交易所需的费用。

以以太坊为例，Gas是用以太坊的货币以太(ETH)支付的。Gas价格以Gwei标明，Gwei本身就是ETH的一个单位――每个Gwei等于0.000000001 ETH (10^-9^ ETH)。例如，您可以说您的Gas成本为1 Gwei，而不是说您的Gas成本为0.000000001以太。

## 为什么存在Gas费用？

简而言之，Gas费用有助于确保区块链网络的安全。在网络上执行的每次计算都需要收费，这样可以防止不良行为者给网络带来垃圾信息。

为了防止代码中出现无意或恶意的无限循环或其他计算浪费，要求每个交易对可以采用的代码执行计算步骤设置一个限制。这个限制称为Gas Limit，它表示您愿意为执行交易支付的最大Gas数量。

如果您的交易执行过程中耗尽了Gas Limit，那么交易将失败，并且您已经支付的Gas费用将不会退还。这就像您的汽车在半路没油了，您不仅要付钱买油，还要付钱拖车。

因此，在发送交易之前，您需要估计交易所需的Gas数量，并设置合理的Gas Limit和Gas价格。一般来说，简单的转账交易所需的Gas数量比复杂的智能合约交易少得多。

## 如何计算交易费用？

区块链网络上的交易费用是由两个因素决定的：Gas数量和Gas价格。两者相乘就得到了总交易费用。

例如，在以太坊上发送一笔转账交易，假设需要21000个Gas，而当前的Gas价格是100 Gwei。那么总交易费用就是：

```
21000 * 100 Gwei = 2100000 Gwei = 0.0021 ETH
```

如果以太坊的价格是1800美元，那么这笔交易的手续费就是：

```
0.0021 ETH * 1800 USD = 3.78 USD
```

当然，这只是一个简单的例子。在实际情况中，区块链网络上的Gas价格会根据供需关系而变化。当网络拥堵时，用户会提高他们愿意支付的Gas价格，以便让他们的交易更快地被打包到区块中。反之，当网络空闲时，用户会降低他们愿意支付的Gas价格，以便节省成本。

因此，在发送交易之前，您需要查询当前网络上的平均或推荐的Gas价格，并根据您对交易速度和成本的偏好来设置合适的Gas价格。

## 如何优化交易费用？

在区块链网络上进行交易时，我们都希望能够节省手续费，并且尽可能快地完成交易。为了实现这一目标，我们可以采取以下一些措施：

- 在网络空闲时发送交易。一般来说，在周末或夜间等时间段，区块链网络上的交易量会比较低，因此Gas价格也会相应降低。您可以利用这些时间段来发送交易，以便获得更低的手续费。
- 使用Gas价格预测工具。有一些网站或应用程序可以提供区块链网络上的Gas价格预测，例如[ETH Gas Station]或[Gas Now]。您可以通过这些工具来了解当前和未来的Gas价格趋势，并根据您的需求来选择合适的Gas价格。
- 使用Gas Limit估算工具。有一些网站或应用程序可以提供区块链网络上的Gas Limit估算，例如[Etherscan]或[MetaMask]。您可以通过这些工具来估计您的交易所需的Gas数量，并设置合理的Gas Limit，以避免交易失败或浪费Gas。
- 使用批量交易或聚合交易服务。有一些网站或应用程序可以提供区块链网络上的批量交易或聚合交易服务，例如[1inch]或[Zapper]。您可以通过这些服务来将多个交易合并为一个交易，或者利用其他用户的交易来降低您的手续费。

在以太坊区块链上，每个操作都有一个对应的Gas消耗表，您可以参考这个表来了解不同类型的操作所需的Gas数量。例如：

- 将两个数字相加要花费3个Gas；
- 获取账户余额会花费400个Gas；
- 发送一笔转账交易花费21000个Gas；
- 调用一个智能合约函数花费的Gas取决于函数的复杂度和数据量。

除了基本的操作，还有一些特殊的操作，例如存储或修改数据，会有额外的Gas消耗。例如：

- 在合约中存储一个32字节的值要花费20000个Gas；
- 修改一个已经存储的值要花费5000个Gas；
- 清除一个已经存储的值要花费负10000个Gas（即退还10000个Gas）。

这些特殊的操作是为了鼓励合约开发者优化他们的代码和数据结构，以减少对区块链存储空间的占用。

如果您想要计算您的智能合约函数的Gas消耗，您可以使用一些工具来帮助您估算。例如：

- [Etherscan]提供了一个在线编译器，可以让您编写和测试智能合约，并显示每个函数的Gas消耗。
- [MetaMask]提供了一个浏览器插件，可以让您在发送交易之前预览交易所需的Gas数量和费用。
- [Remix]提供了一个集成开发环境，可以让您编写、部署和调试智能合约，并显示每次执行的Gas消耗。

### Gas War

Gas War是指在区块链网络上发生的一种竞争现象，当有很多用户想要在同一时间发送交易时，他们会提高自己的Gas价格，以便让自己的交易更快地被打包到区块中。这样就会导致网络上的Gas价格飙升，甚至超过一般用户能够承受的范围。

Gas War通常发生在以下几种情况：

- 有受欢迎的NFT项目发售时，很多用户想要抢购限量的NFT，例如Doodles、MekaVerse等；
- 有重大的市场行情变化时，很多用户想要及时地买入或卖出加密资产，例如比特币或以太坊；
- 有重要的区块链事件或升级时，很多用户想要在截止日期前完成某些操作，例如领取空投或参与快照。

Gas War对于区块链网络来说是一把双刃剑，一方面它反映了网络上的活跃度和热度，另一方面它也增加了网络上的拥堵和成本。对于用户来说，参与Gas War需要权衡交易速度和交易费用之间的关系，以及自己对交易结果的期望和风险。

# MEV和三明治攻击

## 什么是MEV？

MEV是最大可提取价值（Maximum Extractable Value）的缩写，它指的是区块链网络上的验证者（例如矿工或者共识节点）通过在区块中添加、排除或者重新排序交易，可以从区块生产中提取的超过标准区块奖励和交易费用的最大值。

例如，在以太坊上，验证者可以通过以下方式获取MEV：

- 在区块中包含一笔利用去中心化交易所（DEX）的价格差异进行套利的交易，从而获得套利收益；
- 在区块中包含一笔清算借贷协议中过度负债的用户的交易，从而获得清算奖励；
- 在区块中包含一笔抢购限量或者低价的非同质化代币（NFT）的交易，从而获得NFT的价值；
- 在区块中排除或者延迟一笔对手方的交易，从而获得市场优势或者避免损失。

## 为什么存在MEV？

MEV的存在是由于区块链网络上的以下特点造成的：

- 交易透明性：任何人都可以在内存池中查看待打包的交易，从而发现有利可图的机会；
- 交易延迟：由于区块链网络有一定的出块时间和确认时间，交易在提交和执行之间有一定的时间差，这给了验证者和其他参与者操纵交易的空间；
- 交易可复制性：任何人都可以复制内存池中的交易，并用自己的地址或者更高的交易费替换原来的地址或者交易费，从而抢先执行该交易；
- 价格滑点：由于DEX是根据储备金模型来确定价格的，每笔交易都会影响资产池中的价格，导致买卖双方之间的价格差异，这给了验证者和其他参与者利用价格滑点进行套利的机会。

## MEV有什么影响？

MEV对于区块链网络和用户来说，既有积极的作用，也有消极的影响。

优点：

- MEV可以激励验证者维护网络安全，因为他们可以通过获取MEV来增加收入，从而抵消成本；
- MEV可以促进市场效率，因为验证者和其他参与者可以通过套利等方式来消除市场上的价格差异和无效状态；
- MEV可以创造创新，因为验证者和其他参与者可以通过开发新的工具和服务来寻找和提取MEV，从而推动区块链技术的进步。

缺点：

- MEV可以增加网络拥堵，因为验证者和其他参与者会竞相发送高交易费的交易来获取MEV，从而占用网络资源；
- MEV可以降低网络公平性，因为验证者和其他参与者会优先处理高交易费或者有利可图的交易，从而损害普通用户的利益；
- MEV可以破坏网络安全性，因为验证者和其他参与者会为了获取MEV而采取一些恶意行为，例如重组区块、串谋作弊、攻击竞争对手等

## 三明治攻击

## 什么是三明治攻击？

三明治攻击（sandwich attacks）是DeFi里流行的抢先交易技术的一种。 为了形成一个“三明治”交易，攻击者（或者我们叫他掠夺性交易员）会找到一个待处理的受害者交易，然后试图通过前后的交易夹击该受害者。

这种策略来源于买卖资产从而操作资产价格的方法。区块链的透明度、以及执行订单的延迟（往往在网络拥堵情况下），使抢先交易更加容易，并极大降低了交易的安全性。

所有区块链交易都可在内存池（mempool）中查到。一旦掠夺性交易者注意到潜在受害者的待定资产X交易被用于资产Y，他们就会在受害者之前购买资产Y。掠夺性交易者知道受害者的交易将提高资产的价格，从而计划以较低的价格购买Y资产，让受害者以较高的价格购买，最后再以较高的价格出售资产。

## 三明治攻击有哪些类型？

根据攻击者和受害者的角色不同，三明治攻击可以分为以下两种类型：

- 流动性获得者攻击流动性获得者：在这种情况下，流动性获得者试图攻击在区块链上有待处理的AMM DEX交易的流动性获得者。看到等待批准的交易，掠夺者发出两个后续交易（前置和后置）以从交易者的交易中受益。现在，通过一个流动性池和货币对连接了三个待处理的交易。矿工必须选择哪笔交易首先获得批准。这就是掠夺者可以通过实际贿赂矿工来影响这个决定的地方，即支付更高或更低的交易费用。
- 流动性提供者攻击流动性获得者：在这种情况下，流动性提供者试图攻击流动性获得者。一切的开始都是一样的，攻击者在区块链上看到一个待处理的交易，然后执行三个交易：
  - 消除流动性：抢占先机（通过减少资产的市场流动性来增加受害者的滑点）
  - 添加流动性：恢复运行（将资金池中的流动性恢复到攻击前的水平）
  - 用B交换A：返回运行（将A的资产余额恢复到攻击前的状态）

在这次攻击中，攻击者在受害者的交易执行之前从流动性池中提取所有资产。在这样做的过程中，掠夺者放弃了受害者交易的佣金。流动性获得者的交易执行后，攻击者将流动性重新添加到池中，并将资产交换回原来的状态。这样，攻击者就可以从受害者的交易中获得利润，而不会留下任何痕迹。

## 如何实现和防御三明治攻击？

要实现三明治攻击，攻击者需要具备以下条件：

- 能够监控内存池中的待处理交易
- 能够快速地发送和取消交易
- 能够影响矿工对交易的排序和打包

要防御三明治攻击，用户和开发者可以采取以下措施：

- 用户：
  - 使用更高的gas价格来提高交易的优先级
  - 使用更低的滑点限制来减少交易被利用的可能性
  - 使用更小的交易量来降低被注意到的风险
  - 使用更安全和可信的DeFi服务和协议
- 开发者：
  - 使用更复杂和随机的价格机制来防止价格被操纵
  - 使用更公平和透明的交易机制来防止交易被抢先
  - 使用更智能和灵活的合约逻辑来防止合约被利用
  - 使用更多和多样的安全工具和审计来防止漏洞被发现

## 代码例子

为了更好地理解三明治攻击，我们可以用代码例子来模拟一次流动性获得者攻击流动性获得者的场景。我们假设有一个名为UniswapV2Router02的合约，提供了swapExactTokensForTokens函数，允许用户在两个代币之间进行交换。我们还假设有一个名为Sandwicher的合约，用于执行三明治攻击。我们使用Solidity语言编写合约，并使用Etherscan API来监控内存池。

首先，我们定义UniswapV2Router02合约的接口：

```solidity
interface IUniswapV2Router02 {
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}
```

然后，我们定义Sandwicher合约：

```solidity
contract Sandwicher {
    // UniswapV2Router02合约地址
    address public constant UNISWAP_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    // WETH代币地址
    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    // DAI代币地址
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    // UniswapV2Router02合约实例
    IUniswapV2Router02 public uniswapRouter;
    
    constructor() {
        // 初始化UniswapV2Router02合约实例
        uniswapRouter = IUniswapV2Router02(UNISWAP_ROUTER);
    }
    
    // 收到ETH时自动调用
    receive() external payable {
        // 检查是否有足够的ETH余额
        require(msg.value > 0, "Insufficient ETH balance");
        // 监控内存池中的待处理交易
        monitorMempool();
    }
    
    // 监控内存池中的待处理交易
    function monitorMempool() internal {
        // 使用Etherscan API获取内存池中的交易列表
        // https://docs.etherscan.io/api-endpoints/accounts#get-mempool-transactions-by-address
        string memory url = string(abi.encodePacked(
            "https://api.etherscan.io/api?module=account&action=txlistinternal&address=",
            UNISWAP_ROUTER,
            "&apikey=YourApiKeyToken"
        ));
        // 发送HTTP GET请求
        (bool success, bytes memory data) = url.delegatecall("");
        // 检查请求是否成功
        require(success, "HTTP request failed");
        // 解析返回的JSON数据
        (bool status, string memory message, Transaction[] memory transactions) = abi.decode(data, (bool, string, Transaction[]));
        // 检查返回的状态是否为1（成功）
        require(status, message);
        // 遍历交易列表
        for (uint i = 0; i < transactions.length; i++) {
            // 获取当前交易
            Transaction memory tx = transactions[i];
            // 检查当前交易是否是swapExactTokensForTokens函数的调用
            if (tx.input == keccak256("swapExactTokensForTokens(uint256,uint256,address[],address,uint256)")) {
                // 解析交易输入参数
                (uint amountIn, uint amountOutMin, address[] memory path, address to, uint deadline) = abi.decode(tx.input, (uint256,uint256,address[],address,uint256));
                // 检查交易路径是否是WETH-DAI或者DAI-WETH
                if ((path[0] == WETH && path[1] == DAI) || (path[0] == DAI && path[1] == WETH)) {
                    // 执行三明治攻击
                    sandwichAttack(amountIn, amountOutMin, path, to, deadline);
                }
            }
        }
    }
    
    // 执行三明治攻击
    function sandwichAttack(uint amountIn, uint amountOutMin, address[] memory path, address to, uint deadline) internal {
        // 计算前置交易的输入和输出金额
        uint frontAmountIn = amountIn / 10; // 假设前置交易使用10%的输入金额
        uint frontAmountOutMin = uniswapRouter.getAmountsOut(frontAmountIn, path)[1]; // 根据输入金额和路径计算输出金额的最小值
        
        // 计算后置交易的输入和输出金额
        uint backAmountIn = amountIn / 10; // 假设后置交易使用10%的输入金额
        uint backAmountOutMin = uniswapRouter.getAmountsOut(backAmountIn, path)[1]; // 根据输入金额和路径计算输出金额的最小值
        
                // 发送前置交易，使用更高的gas价格来抢先执行
        uniswapRouter.swapExactTokensForTokens{value: frontAmountIn * 2}(frontAmountIn, frontAmountOutMin, path, address(this), deadline);
        
        // 等待受害者的交易被执行
        
        // 发送后置交易，使用更低的gas价格来延后执行
        uniswapRouter.swapExactTokensForTokens{value: backAmountIn / 2}(backAmountIn, backAmountOutMin, path, address(this), deadline);
        
        // 计算攻击者的利润
        uint profit = 0;
        if (path[0] == WETH) {
            // 如果交易路径是WETH-DAI，那么攻击者的利润是DAI的余额
            profit = IERC20(DAI).balanceOf(address(this));
        } else {
            // 如果交易路径是DAI-WETH，那么攻击者的利润是WETH的余额
            profit = IERC20(WETH).balanceOf(address(this));
        }
        
        // 将利润转移到攻击者的地址
        IERC20(path[1]).transfer(msg.sender, profit);
    }
    
    // 定义交易结构体
    struct Transaction {
        string blockNumber;
        string timeStamp;
        string hash;
        string nonce;
        string blockHash;
        string from;
        string contractAddress;
        string to;
        string value;
        string tokenName;
        string tokenSymbol;
        string tokenDecimal;
        string transactionIndex;
        string gas;
        string gasPrice;
        string gasUsed;
        string cumulativeGasUsed;
        string input;
        string confirmations;
    }
}
```

代码中的函数和变量如下：

- UNISWAP_ROUTER：这是一个常量，表示UniswapV2Router02合约的地址，用于在两个代币之间进行交换。
- WETH：这是一个常量，表示WETH代币的地址，WETH是一种可以在以太坊网络上交易的包装以太币（wrapped ether）。
- DAI：这是一个常量，表示DAI代币的地址，DAI是一种稳定币，与美元挂钩。
- uniswapRouter：这是一个变量，表示UniswapV2Router02合约的实例，用于调用合约的函数。
- receive()：这是一个函数，当合约收到ETH时自动调用，用于检查ETH余额并监控内存池中的待处理交易。
- monitorMempool()：这是一个内部函数，用于监控内存池中的待处理交易，并筛选出符合条件的交易进行三明治攻击。
- url：这是一个局部变量，表示Etherscan API的请求地址，用于获取内存池中的交易列表。
- success：这是一个局部变量，表示HTTP请求是否成功。
- data：这是一个局部变量，表示HTTP请求返回的数据。
- status：这是一个局部变量，表示Etherscan API返回的状态是否为1（成功）。
- message：这是一个局部变量，表示Etherscan API返回的消息。
- transactions：这是一个局部变量，表示Etherscan API返回的交易列表。
- tx：这是一个局部变量，表示当前遍历到的交易。
- input：这是一个属性，表示交易的输入数据。
- amountIn：这是一个局部变量，表示交易输入的代币数量。
- amountOutMin：这是一个局部变量，表示交易输出的代币数量的最小值。
- path：这是一个局部变量，表示交易的路径，即两个代币的地址数组。
- to：这是一个局部变量，表示交易的接收者地址。
- deadline：这是一个局部变量，表示交易的截止时间。
- sandwichAttack()：这是一个内部函数，用于执行三明治攻击。它接受五个参数，分别对应受害者交易的输入参数。它会发送前置和后置交易，并计算并转移利润。
- frontAmountIn：这是一个局部变量，表示前置交易输入的代币数量。假设为受害者交易输入数量的10%。
- frontAmountOutMin：这是一个局部变量，表示前置交易输出的代币数量的最小值。根据输入数量和路径计算得出。
- backAmountIn：这是一个局部变量，表示后置交易输入的代币数量。假设为受害者交易输入数量的10%。
- backAmountOutMin：这是一个局部变量，表示后置交易输出的代币数量的最小值。根据输入数量和路径计算得出。
- profit：这是一个局部变量，表示攻击者从三明治攻击中获得的利润。根据交易路径不同，可能为DAI或WETH余额。
- Transaction：这是一个结构体，定义了交易的属性。包括区块号、时间戳、哈希、随机数、区块哈希、发送者、合约地址、接收者、价值、代币名称、代币符号、代币小数位、交易索引、gas、gas价格、gas消耗、累积gas消耗、输入数据和确认数。

