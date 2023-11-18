// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../ToysLegendERC721.sol";
import "./utils/PixelsManager.sol";

contract Land is ToysLegendERC721, PixelsManager {
    constructor() ToysLegendERC721(
        "Land",
        "LAND",
        "LAND"
    ) PixelsManager(26, 4) {}

    event LandMinted(
        address indexed owner,
        int indexed y,
        uint indexed x,
        uint256 tokenId,
        uint position,
        uint variation
    );

    function safeMint(
        address to,
        int y,
        uint x,
        uint position,
        uint variation
    ) public onlyRole(MINTER_ROLE) returns(uint256) {
        uint _tokenId = super.safeMint(to);

        _addLandToPixel(
            y,
            x,
            _tokenId,
            position
        );

        emit LandMinted(
            to,
            y,
            x,
            _tokenId,
            position,
            variation
        );

        return _tokenId;
    }
}
