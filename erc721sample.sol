// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract V11NFTToken is ERC721, ERC721URIStorage, Ownable {
    using Strings for uint256;

    error TokenNotExist(uint256 id);
    uint256 private lastId;

    constructor() ERC721("V11NFTToken", "V11NFT") Ownable(msg.sender) {}

    function safeMint(address to) public onlyOwner {
        string memory baseUri = _baseUri();
        bytes memory imageUri = abi.encodePacked(
            baseUri,
            lastId.toString(),
            ".jpg"
        );
        string memory uri = string(
            abi.encodePacked(
                abi.encodePacked(
                    '{"name":"',
                    "V11NFT Number ",
                    lastId.toString(),
                    '","description":"',
                    "A V11NFT Number.",
                    ' All data is stored onchain."',
                    ',"image":"',
                    imageUri,
                    '"}'
                )
            )
        );
        _safeMint(to, lastId);
        _setTokenURI(lastId, uri);
        lastId++;
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function _baseUri() internal pure returns (string memory) {
        return "https://vuk-dapp.s3.eu-west-1.amazonaws.com/";
    }
}
