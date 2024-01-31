// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";


/**
 * @title V1NFTToken
   * @dev bank implementation
   * @custom:dev-run-script scripts/deploy_with_ethers.ts
   */

contract V1Token is IERC721, IERC721Metadata {

    using Strings for uint256;

    error NotApproved(address account);
    error TokenNotExist(uint256 id);
    error InvalidAddress();
    error NotSafeAddress(address account);

    string public name;
    string public symbol;
    uint256 private lastId;
    mapping(address => uint256) public balanceOf;
    mapping(uint256 => address) public ownerOf;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    constructor() {
        name = "V1NFToken";
        symbol = "V1NFT";
    }

    function transferFrom(address _from, address _to, uint256 _id) external {
        _transfer(_from, _to, _id);
    }


    function approve(address _to, uint256 _id) external {
        address owner = ownerOf[_id];
        if (owner != msg.sender && !isApprovedForAll(owner, msg.sender)) {
            revert NotApproved(msg.sender);
        }
        _tokenApprovals[_id] = _to;
        emit Approval(owner, _to, _id);
    }

    function getApproved(uint256 _id) view public returns (address) {
        return _tokenApprovals[_id];
    }


    function setApprovalForAll(address operator, bool approved) external {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);

    }

    function isApprovedForAll(address owner, address operator) view public returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function safeTransferFrom(address _from, address _to, uint256 _id) external {
        if (_to.code.length > 0) {
            revert NotSafeAddress(_to);
        }
        _transfer(_from, _to, _id);
    }

    function safeTransferFrom(address _from, address _to, uint256 _id, bytes calldata data) virtual external {}

    function supportsInterface(bytes4 interfaceId) virtual external view returns (bool) {}

    function mint (address _to) public {
        if (_to == address(0)) {
            revert InvalidAddress();
        }
        ownerOf[lastId] = _to;
        balanceOf[_to]++;
        lastId++;
    }

    function tokenURI(uint256 _id) external view returns (string memory) {
        if (_id >= lastId) {
            revert TokenNotExist(_id);
        }
        string memory baseUri = _baseUri();
        // return string(abi.encodePacked(baseUri, _id.toString(), '.jpg'));

        bytes memory imageUri = abi.encodePacked(baseUri, _id.toString(), '.jpg');
        return string(abi.encodePacked('data:application/json;base64,',
            Base64.encode(bytes(abi.encodePacked(
                '{"name":"', 'V1NFT Number ', _id.toString(),'","description":"', 'A V1NFT Number.', 'All data is stored onchain."',
                ',"image":"',
                'data:image/svg+xml;base64,', imageUri,'"}')))
        ));
    }

    function _transfer (address _from, address _to, uint256 _id) internal {
        address owner = ownerOf[_id];
        if (owner == address(0)) {
            revert TokenNotExist(_id);
        }
        if (_from != owner && getApproved(_id) != _from && !isApprovedForAll(owner, _from) || _to == address(0)  ) {
            revert NotApproved(_from);
        }
        ownerOf[_id] = _to;
        balanceOf[_from]--;
        balanceOf[_to]++;
        emit Transfer(_from, _to, _id);
    }

    function _baseUri () internal pure returns (string memory) {
        return "https://vuk-dapp.s3.eu-west-1.amazonaws.com/";
    }
}
