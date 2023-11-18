// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../ToysLegendERC721.sol";

contract MunitionFactory is ToysLegendERC721 {
    constructor() ToysLegendERC721(
        "Munition Factory",
        "MFACTORY",
        "MUNITION_FACTORY"
    ) {}
}
