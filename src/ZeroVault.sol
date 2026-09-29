// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ZeroVault {
    address payable public immutable DESTINATION_WALLET;
    bytes32 public immutable HASH_LOCK;
    bool public isLocked = true;

    constructor(address payable _coldWallet, bytes32 _hashLock) payable {
        DESTINATION_WALLET = _coldWallet;
        HASH_LOCK = _hashLock;
    }

    function unlockVault(string memory _secret) external {
        require(isLocked, "Vault is empty!");
        // استخدام صيغة التشفير المعيارية bytes() لضمان المطابقة المطلقة
        require(keccak256(bytes(_secret)) == HASH_LOCK, "Invalid Secret!");
        isLocked = false;
        (bool success, ) = DESTINATION_WALLET.call{value: address(this).balance}("");
        require(success, "Transfer Failed");
    }
}
