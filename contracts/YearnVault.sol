// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./ERC20.sol";

contract YearnVault is ERC20 {
    ERC20 public underlyToken ;
    address public addr;
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(address _addr) ERC20("vSCFX", "vSCFX", 10000) public { 
        addr = _addr;
        underlyToken = ERC20(addr);
    }

    function setAddr(address _addr) public {    //设置underlyToken的地址
        addr = _addr;
        underlyToken = ERC20(addr);
    }

    function deposit(uint256 amount, address recipient) external returns (uint256) {
        //require(underlyToken.balanceOf(msg.sender) > amount, "balance not enough");
        underlyToken.transferFrom(recipient, address(this), amount);    
        uint256 shares = amount / 2;  //假设存100 underlyToken 得 50 LP
        _mint(recipient, shares);
    }

    function withdraw(
        uint256 _amount,    //underlyToken 的 amount
        address _destination,
        uint256 _minUnderlying  //不知道干啥的
    ) external returns (uint256 shares) {
        shares = _amount / 2;
        _burn(_destination, _amount);    //销毁LP
        
        underlyToken.transfer(_destination,  _amount); //返回underlyToken
        return shares;    
    }

    // // Returns the amount of underlying per each unit [1e18] of yearn shares
    // function pricePerShare() external view returns (uint256);

    // function governance() external view returns (address);

    // function setDepositLimit(uint256) external;

    // function totalSupply() external view returns (uint256);

    // function totalAssets() external view returns (uint256);

    // function apiVersion() external view returns (string memory);
}
