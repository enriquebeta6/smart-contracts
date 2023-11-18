// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../ToysLegendERC721.sol";

contract Toy is ToysLegendERC721 {
    constructor() ToysLegendERC721(
        "Toy",
        "TOY",
        "TOY"
    ) {}
}
