// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OverflowDemo {
    uint8 public myNumber = 255;
    
    function increment() public {
        myNumber += 1;
    }
}