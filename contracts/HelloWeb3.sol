// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelloWeb3 {
    string public message;

    constructor() {
        message = "Hello, Web3!";
    }

    function setMessage(string memory newMessage) public  {
        message = newMessage;
    }

    function getMessage() public view returns (string memory) {
        return message;
    }
}