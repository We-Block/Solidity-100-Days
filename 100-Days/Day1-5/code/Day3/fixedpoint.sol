// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 定义一个基于 uint256 的自定义类型 UFixed
type UFixed is uint256;

// 一个用于在 UFixed 类型上进行算术运算的库
library UFixedMath {
    // UFixed 类型的小数位数
    uint constant decimals = 18;

    // UFixed 类型的乘数
    uint constant multiplier = 10**decimals;

    // 加法运算，溢出时回滚
    function add(UFixed a, UFixed b) internal pure returns (UFixed) {
        return UFixed.wrap(UFixed.unwrap(a) + UFixed.unwrap(b));
    }

    // 乘法运算，溢出时回滚
    function mul(UFixed a, UFixed b) internal pure returns (UFixed) {
        // 使用 mulDiv 来处理小数位数
        return UFixed.wrap(mulDiv(UFixed.unwrap(a), UFixed.unwrap(b), multiplier));
    }

    // 除法运算，除以零时回滚
    function div(UFixed a, UFixed b) internal pure returns (UFixed) {
        // 使用 mulDiv 来处理小数位数
        return UFixed.wrap(mulDiv(UFixed.unwrap(a), multiplier, UFixed.unwrap(b)));
    }

    // 一个辅助函数，用于进行带有正确舍入的乘法和除法运算
    function mulDiv(
        uint x,
        uint y,
        uint z
    ) internal pure returns (uint) {
        // Solidity 只在除以零时自动断言
        require(z > 0, "UFixedMath: division by zero");
        // 确保结果小于 2^256，否则会溢出
        require(x <= type(uint).max / y, "UFixedMath: multiplication overflow");

        uint a = x * y;
        uint b = a / z;
        uint c = a % z;
        if (c * 2 >= z) {
            // 向上舍入，加一
            return b + 1;
        } else {
            // 向下舍入，截断
            return b;
        }
    }
}

contract FixedPoint {
    using UFixedMath for UFixed;

    function multiply(UFixed x, UFixed y) public pure returns (UFixed) {
        return x.mul(y);
    }

    function divide(UFixed x, UFixed y) public pure returns (UFixed) {
        return x.div(y);
    }
}