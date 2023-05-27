// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Division {
    /** 
     * @dev Divides two unsigned 8-bit integers, truncates.
     * @param x The first uint8 operand
     * @param y The second uint8 operand
     * @return The result of dividing x by y
     */
    function divide(uint8 x, uint8 y) public pure returns (uint8) {
        return x / y;
    }
    /** 
     * @dev Returns the remainder after dividing two signed 8-bit integers.
    * @param x The first int8 operand
     * @param y The second int8 operand
     * @return The result of x % y
     */
    function remainder(int8 x, int8 y) public pure returns (int8) {
        return x % y;
    }
}