// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Power {
    /**
     * @dev Returns x raised to the power of y
     * @param x The base
     * @param y The exponent
     * @return x ** y
     */
    function power(uint x, uint y) public pure returns (uint) {
        return x ** y;
    }
}