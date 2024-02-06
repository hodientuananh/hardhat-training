// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "hardhat/console.sol";

contract TokenVault {
    address public tkxToken;

    mapping(address => uint256) public depositedAmounts;
    mapping(address => uint256) public balances;


    constructor(address _tkxToken) {
        tkxToken = _tkxToken;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    function deposit(address from, uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        IERC20(tkxToken).transferFrom(from, address(this), amount);

        unchecked {
            balances[from] -= amount;
            balances[address(this)] += amount;
            depositedAmounts[from] += amount;
        }
    }

    function withdraw(address from, uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(depositedAmounts[from] < amount, "deposit is not enough");

        IERC20(tkxToken).transfer(from, amount);

        unchecked {
            balances[address(this)] -= amount;
            balances[from] += amount;
            depositedAmounts[from] -= amount;
        }

        emit Transfer(address(this), from, amount);
    }

    function getDepositedAmount(address sender) public view returns (uint256) {
        return depositedAmounts[sender];
    }
}
