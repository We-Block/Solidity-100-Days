// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Overflow {
    /** 
     * @dev Adds two unsigned 8-bit integers, wraps on overflow.
     * @param x The first uint8 operand
     * @param y The second uint8 operand
     * @return The result of adding x and y
     */
    function add(uint8 x, uint8 y) public pure returns (uint8) {
        return x + y;
    }

    /**
     * @dev Adds two unsigned 8-bit integers, wraps on overflow.
     * @param x The first uint8 operand
     * @param y The second uint8 operand
     * @return The result of adding x and y
     */
    function uncheckedAdd(uint8 x, uint8 y) public pure returns (uint8) {
        unchecked {
            return x + y;
        }
    }
}