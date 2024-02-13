// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/Dexaran/ERC223-token-standard/blob/development/token/ERC223/IERC223Recipient.sol";

/**
 * @title V1Token
 * @dev bank implementation
 * @custom:dev-run-script scripts/deploy_with_ethers.ts
 */

contract V1_223Token is IERC223Recipient {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event TokenReceived(
        address indexed tknContract,
        address indexed spender,
        uint256 value
    );

    error InsufficientBalance(address account);
    error InsufficientAllowance(address account);
    error InvalidAddress();

    string public name;
    string public symbol;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    address private _owner;
    ERC223TransferInfo private tkn;

    constructor() {
        name = "V1_223_Token";
        symbol = "V1_223";
        totalSupply = 1000000 * 10**decimals();
        _owner = msg.sender;
        _mint(_owner, 100000 * 10**decimals());
    }

    function transfer(address _to, uint256 _value)
    public
    returns (bool success)
    {
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

    function approve(address _spender, uint256 _value)
    public
    returns (bool success)
    {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
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

    function _mint(address _to, uint256 value) internal {
        if (_to == address(0) || _to != _owner) {
            revert InvalidAddress();
        }
        balanceOf[_to] = value;
    }

    function decimals() public pure returns (uint256) {
        return 18;
    }

    function tokenReceived(
        address _from,
        uint256 _value,
        bytes memory _data
    ) public override returns (bytes4) {
        tkn.token_contract = msg.sender;
        tkn.sender = _from;
        tkn.value = _value;
        tkn.data = _data;

        emit TokenReceived(tkn.token_contract, tkn.sender, tkn.value);

        return 0x8943ec02;
    }
}
