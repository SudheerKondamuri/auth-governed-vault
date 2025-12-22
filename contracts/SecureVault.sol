// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAuthorizationManager {
    function verifyAuthorization(
        address vault,
        address recipient,
        uint256 amount,
        uint256 nonce,
        bytes calldata signature
    ) external returns (bool);
}

contract SecureVault {
    IAuthorizationManager public immutable authManager;

    event Deposit(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);

    constructor(address authManagerAddress) {
        require(authManagerAddress != address(0), "invalid auth manager");
        authManager = IAuthorizationManager(authManagerAddress);
    }
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(
        address recipient,
        uint256 amount,
        uint256 nonce,
        bytes calldata signature
    ) external {
        bool ok = authManager.verifyAuthorization(
            address(this),
            recipient,
            amount,
            nonce,
            signature
        );
        require(ok, "not authorized");

        require(address(this).balance >= amount, "insufficient vault balance");

        (bool sent, ) = recipient.call{value: amount}("");
        require(sent, "eth transfer failed");

        emit Withdrawal(recipient, amount);
    }
}
