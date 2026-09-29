// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Test.sol";
import "../src/VulnerableBank.sol";
import "../src/Attacker.sol";

contract AttackTest is Test {
  VulnerableBank bank;
  Attacker attacker;
  function setUp() public {
    bank = new VulnerableBank();
    attacker = new Attacker(address(bank));
    bank.deposit{value: 1 ether}();
  }
  function testReentrancy() public {
    vm.deal(address(attacker), 1 ether);
    attacker.attack{value: 1 ether}();
    assertEq(address(bank).balance, 0);
  }
}
