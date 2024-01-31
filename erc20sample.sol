// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title V1Token
   * @dev bank implementation
   * @custom:dev-run-script scripts/deploy_with_ethers.ts
   */

contract V1Token {

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    error InsufficientBalance(address account);
    error InsufficientAllowance(address account);

    string public name;
    string public symbol;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() {
        name = "V1Token";
        symbol = "V1";
        totalSupply = 1000000000000000000000000;
        balanceOf[msg.sender] = 100000000000000000000000;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (balanceOf[msg.sender] < _value) {
            revert InsufficientBalance(msg.sender);
        }
        unchecked {
            balanceOf[msg.sender] -= _value;
            balanceOf[_to] += _value;
        }
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (balanceOf[_from] < _value) {
            revert InsufficientBalance(_from);
        }
        if (allowance[msg.sender][_from] < _value) {
            revert InsufficientAllowance(_from);
        }
        unchecked {
            balanceOf[_from] -= _value;
            balanceOf[_to] += _value;
            allowance[msg.sender][_from] -= _value;
        }
        emit Transfer(_from, _to, _value);
        return true;
    }
}
