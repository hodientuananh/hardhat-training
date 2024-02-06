// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "hardhat/console.sol";

contract TokenVaultSecret {
    uint256 public constant CONTRACT_SECRET = 123456789;
    address public tkxToken;

    struct User {
        bytes32 randomCode;
        uint256 amount;
    }
    mapping(address => User) public users;

    constructor(address _tkxToken) {
        tkxToken = _tkxToken;
    }

    function deposit(address from, uint256 amount) public {
        bytes32 randomCode = keccak256(abi.encodePacked(
            from,
            amount,
            CONTRACT_SECRET
        ));
        IERC20(tkxToken).transferFrom(from, address(this), amount);
        users[from].randomCode = randomCode;
        users[from].amount += amount;
    }

    function withdrawAll(address to, bytes32 randomCode) public {
        User memory user = users[to];
        uint256 amount = user.amount;

        require(user.randomCode == randomCode, "Invalid random code");

        users[to].amount = 0;
        IERC20(tkxToken).transfer(to, amount);
    }

    function withdraw(address to, bytes32 randomCode, uint256 wdAmount) public {
        User memory user = users[to];

        require(user.randomCode == randomCode, "Invalid random code");
        require(user.amount >= wdAmount, "Exceed amount");

        user.amount -= wdAmount;
        IERC20(tkxToken).transfer(to, wdAmount);
    }

    function getUserInfo(address userAddress) public view returns (User memory) {
        return users[userAddress];
    }

    function getBalance(address userAddress) public view returns (uint256) {
        return users[userAddress].amount;
    }
}
