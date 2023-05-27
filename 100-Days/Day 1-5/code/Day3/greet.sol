// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract HelloWorld {
    /**
     @dev Returns a greeting
    * @return Returns a greeting string
    */
    function greet() public pure returns (string memory) {
        return "Hello World";
    }
}