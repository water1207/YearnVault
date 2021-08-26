// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract YearnVault is ERC20 {
    ERC20 public token ;
    address public addr;
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(address _addr) 
        ERC20(
            string(abi.encodePacked("x", ERC20(_addr).name())),
            string(abi.encodePacked("x", ERC20(_addr).symbol()))
        ) 
    { 
        addr = _addr;
        token = ERC20(addr);
    }

    function setAddr(address _addr) public {    //设置underlyToken的地址
        addr = _addr;
        token = ERC20(addr);
    }

    function deposit(uint256 _amount, address recipient) public {
        uint256 _pool = token.balanceOf(address(this));
        uint256 _before = token.balanceOf(address(this));

        token.transferFrom(msg.sender, address(this), _amount);

        uint256 _after = token.balanceOf(address(this));
        _amount = _after - _before;
        uint256 shares = 0;
        if (totalSupply() == 0) {
            shares = _amount;
        } else {
            shares = _amount * totalSupply() / _pool;
        }
        _mint(recipient, shares);
    }

    function _withdraw(
        uint256 _shares,
        address _destination,
        uint256 _minUnderlying
    ) public returns (uint256){
        uint256 amount = token.balanceOf(address(this)) * _shares / totalSupply();
        require(amount > _minUnderlying, "amount need beyond the min");
        _burn(msg.sender, _shares);

        // Check balance
        uint256 b = token.balanceOf(address(this));
        if (b < amount) {
            //token.transfer(msg.sender, amount);
            token.transfer(_destination, amount);
        }

        //token.transfer(msg.sender, amount);
        token.transfer(_destination, amount);
        return amount;
    }

    // // Returns the amount of underlying per each unit [1e18] of yearn shares
    function pricePerShare() public view returns (uint256){
        return token.balanceOf(address(this)) * 1e18 / totalSupply();
    }

    // function governance() external view returns (address);

    // function setDepositLimit(uint256) external;

    // function totalSupply() external view returns (uint256);

    function totalAssets() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function apiVersion() public view returns (string memory) {
        return "0.3.5";
    }
}
