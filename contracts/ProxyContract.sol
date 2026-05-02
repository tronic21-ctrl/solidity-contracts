// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProxyContract {
    // Storage slot pertama — alamat logic contract aktif
    address public implementation;
    // Storage slot kedua
    address public owner;

    constructor(address _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }

    // Fungsi upgrade — hanya owner
    function upgradeTo(address _newImplementation) public {
        require(msg.sender == owner, "Bukan owner");
        implementation = _newImplementation;
    }

    // Inti dari proxy — semua panggilan diteruskan ke logic contract
    fallback() external payable {
        address impl = implementation;
        
        assembly {
            // Copy calldata ke memory
            calldatacopy(0, 0, calldatasize())
            
            // delegatecall ke logic contract
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            
            // Copy return data
            returndatacopy(0, 0, returndatasize())
            
            // Return atau revert
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}
}