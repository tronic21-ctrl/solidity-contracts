// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyNFT {
    string public name;
    string public symbol;
    uint256 public tokenCounter;

    mapping (address => mapping(address => bool)) private _operatorApprovals;
    mapping (uint256 => address) private _owners;
    mapping (address => uint256) private _balances;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
        tokenCounter = 0;
    }

    function mint (address to) public {
        uint256 tokenID = tokenCounter;
        _owners[tokenID] = to;
        _balances[to] += 1;
        tokenCounter += 1;
    }

    function ownerOf(uint256 tokenID) public view returns (address) {
        address owner = _owners[tokenID];
        require(owner != address(0), "Token tidak exist");
        return owner;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    function transferFrom(address from, address to, uint256 tokenID) public {
        require(
            msg.sender == from || _operatorApprovals[from][msg.sender] == true, "Tidak diizinkan"
            );
        require(to != address(0), "Alamat token tidak valid");
        _owners[tokenID] = to;
        _balances[from] -= 1;
        _balances[to] += 1;
    }

    function setApprovalForAll(address operator, bool approved) public {
        _operatorApprovals[msg.sender][operator] = approved;
    }
}