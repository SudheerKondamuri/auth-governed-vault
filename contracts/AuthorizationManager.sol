// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract AuthorizationManager {
    using ECDSA for bytes32;

   
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
            abi.encodePacked(
                block.chainid,
                vault,
                recipient,
                amount,
                nonce
            )
        );

        require(!usedAuthorization[messageHash], "authorization already used");

        address recoveredSigner = messageHash.recover(signature);

        require(recoveredSigner == AUTH_SIGNER, "invalid signature");

        usedAuthorization[messageHash] = true;

        return true;
    }
}
