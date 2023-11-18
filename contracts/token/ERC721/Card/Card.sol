// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../ToysLegendERC721.sol";

contract Card is ToysLegendERC721 {
    constructor() ToysLegendERC721(
        "Card",
        "CARD",
        "CARD"
    ) {}
}
