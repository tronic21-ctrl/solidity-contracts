// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LogicV2 {
    // HARUS sama persis dengan LogicV1 dan Proxy — jangan diubah urutannya!
    address public implementation;
    address public owner;
    uint256 public value;

    // Fitur lama tetap ada
    function setValue(uint256 _value) public {
        value = _value;
    }

    function getValue() public view returns (uint256) {
        return value;
    }

    // Fitur BARU di V2
    function multiplyValue(uint256 multiplier) public {
        value = value * multiplier;
    }

    function version() public pure returns (string memory) {
        return "V2";
    }
}