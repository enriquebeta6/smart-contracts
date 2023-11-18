// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../ToysLegendERC721.sol";

contract Weapon is ToysLegendERC721 {
    constructor() ToysLegendERC721(
        "Weapon",
        "WEAPON",
        "WEAPON"
    ) {}
}
