// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank {

    // Mapping: setiap address punya balance
    mapping (address => uint256) private balances;

    // Owner contract
    address public owner;

    // Event
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    // Constructor
    constructor() {
        owner = msg.sender;
    }

    // Modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Bukan owner!");
        _;
    }

    // Hanya owner yang bisa lihat total balance contract
    function getContractBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    // Deposit ETH ke Contract
    function deposit() public payable {
        require(msg.value > 0, "Harus deposit lebih dari 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Cek balance sendiri
    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // Withdraw ETH
    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Saldo tidak cukup");
        balances[msg.sender] -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer gagal");
        emit Withdraw(msg.sender, amount);
    }
}