// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract AuthorizationManager {
    address public immutable AUTH_SIGNER;

    mapping(bytes32 => bool) public usedAuthorization;

    constructor(address signer) {
        require(signer != address(0), "invalid signer");
        AUTH_SIGNER = signer;
    }

    function verifyAuthorization(
        address vault,
        address recipient,
        uint256 amount,
        uint256 nonce,
        bytes calldata signature
    ) external returns (bool) {
        bytes32 messageHash = keccak256(
            abi.encodePacked(block.chainid, vault, recipient, amount, nonce)
        );

        require(!usedAuthorization[messageHash], "authorization already used");

        bytes32 ethSignedHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash)
        );

        address recoveredSigner = ECDSA.recover(ethSignedHash, signature);

        require(recoveredSigner == AUTH_SIGNER, "invalid signature");

        usedAuthorization[messageHash] = true;

        return true;
    }
}
