//SPDX-License-Identifier:MIT
pragma solidity >=0.5.0 <0.9.0;
import "./ECDSA.sol";
contract TestEIP712 {
    using ECDSA for bytes32;

    string constant name = "EIP712 Test";
    string constant version = "1.0.0";
    uint256 constant chainId = block.chainId ;

    address constant verifyingContract =
        0x0000000000000000000000000000000000000001;

    bytes32 public DOMAIN_SEPARATOR;

    constructor() public {
        // Calculate the domain separator
        DOMAIN_SEPARATOR = keccak256(
            abi.encodePacked(
                "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)",
                keccak256(bytes(name)),
                keccak256(bytes(version)),
                chainId,
                verifyingContract
            )
        );

    }

    function signData(string memory message, address signer) public {
        // Hash the message
        bytes32 messageHash = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(bytes(message))
            )
        );

        // Sign the message hash
        bytes32 signature = sign(messageHash, signer);

        // Extract the values of v, r, and s from the signature
        uint8 v = uint8(signature[64] + 27);
        bytes32 r = signature[0:32];
        bytes32 s = signature[32:64];

        // Verify the signature
        address recovered = ecrecover(messageHash, v, r, s);
        assert(recovered == signer, "Signature verification failed");
    }
}
