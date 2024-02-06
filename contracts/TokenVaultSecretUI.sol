// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "hardhat/console.sol";

contract TokenVaultSecretUI {
    uint256 public constant CONTRACT_SECRET = 123456789;

    struct User {
        bytes32 randomCode;
        uint256 amount;
    }
    struct PairTokenAddr {
        address tkAddr;
        address userAddr;
    }
    mapping(bytes32 => User) public users;

    constructor() {
    }

    function getHashPair(address addr, address tkAddr) public pure returns (bytes32) {
        PairTokenAddr memory pair = PairTokenAddr(addr, tkAddr);
        bytes32 hashPair = keccak256(abi.encode(pair));
        return hashPair;
    }

    function deposit(address from, uint256 amount, address tkAddr) public returns (bytes32) {
        bytes32 randomCode = keccak256(abi.encodePacked(
            from,
            tkAddr,
            CONTRACT_SECRET
        ));
        IERC20(tkAddr).transferFrom(from, address(this), amount);

        bytes32 hashPair = getHashPair(from, tkAddr);

        users[hashPair].randomCode = randomCode;
        users[hashPair].amount += amount;
        return randomCode;
    }

    function withdrawAll(address to, bytes32 randomCode, address tkAddr) public {
        bytes32 hashPair = getHashPair(to, tkAddr);
        uint256 amount = users[hashPair].amount;

        require(users[hashPair].randomCode == randomCode, "Invalid random code");

        users[hashPair].amount = 0;
        IERC20(tkAddr).transfer(to, amount);
    }


    function withdraw(address to, bytes32 randomCode, uint256 amount, address tkAddr) public {
        bytes32 hashPair = getHashPair(to, tkAddr);

        require(users[hashPair].randomCode == randomCode, "Invalid random code");
        require(users[hashPair].amount >= amount, "Exceed amount");

        users[hashPair].amount -= amount;
        IERC20(tkAddr).transfer(to, amount);
    }

    function getUserInfo(address userAddress, address tkAddr) public view returns (User memory) {
        bytes32 hashPair = getHashPair(userAddress, tkAddr);
        return users[hashPair];
    }

    function getBalance(address userAddress, address tkAddr) public view returns (uint256) {
        bytes32 hashPair = getHashPair(userAddress, tkAddr);
        return users[hashPair].amount;
    }
}
