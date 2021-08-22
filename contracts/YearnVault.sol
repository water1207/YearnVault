// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./ERC20.sol";

contract YearnVault is ERC20 {
    ERC20 public underlyToken ;
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    constructor() ERC20("GameItem", "ITM", 100) public { 
        underlyToken = ERC20(0x843b1940dCf1238c235eE38AB1462Ecb2A5c1e55);
    }

    function deposit(uint256 amount, address recipient) external returns (uint256) {
        //require(underlyToken.balanceOf(msg.sender) > amount, "balance not enough");
        underlyToken.transferFrom(recipient, address(this), amount);
        return 0;
    }

    // function withdraw(
    //     uint256,
    //     address,
    //     uint256
    // ) external returns (uint256);

    // // Returns the amount of underlying per each unit [1e18] of yearn shares
    // function pricePerShare() external view returns (uint256);

    // function governance() external view returns (address);

    // function setDepositLimit(uint256) external;

    // function totalSupply() external view returns (uint256);

    // function totalAssets() external view returns (uint256);

    // function apiVersion() external view returns (string memory);
}
