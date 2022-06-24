// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../ToysLegendERC721.sol";

contract Skin is ToysLegendERC721 {
    constructor() ToysLegendERC721(
        "Skin",
        "SKIN",
        "SKIN"
    ) {}
}
