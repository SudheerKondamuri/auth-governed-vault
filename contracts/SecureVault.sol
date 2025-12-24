// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AuthorizationManager} from "./AuthorizationManager.sol";

contract SecureVault {
    AuthorizationManager public immutable authManager;
    
    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(address indexed recipient, uint256 amount);

    constructor(address _authManager) {
        authManager = AuthorizationManager(_authManager);
    }

    // Explicitly handle plain Ether transfers
    receive() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    // Fallback in case data is sent
    fallback() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(
        address payable recipient,
        uint256 amount,
        uint256 nonce,
        bytes calldata signature
    ) external {
        require(address(this).balance >= amount, "Insufficient vault balance");

        bool authorized = authManager.verifyAuthorization(
            address(this),
            recipient,
            amount,
            nonce,
            signature
        );
        
        require(authorized, "Authorization failed");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "ETH transfer failed");

        emit Withdrawn(recipient, amount);
    }
}