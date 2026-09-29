// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableBank {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    // النسخة المحمية - الحل
    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        
        balances[msg.sender] -= _amount; // 1- نقص قبل

        (bool success, ) = msg.sender.call{value: _amount}(""); // 2- من بعد ابعث
        require(success, "Transfer failed");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
