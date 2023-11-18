// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../ToysLegendERC721.sol";

contract BatteryFactory is ToysLegendERC721 {
    constructor() ToysLegendERC721(
        "Battery Factory",
        "BFACTORY",
        "BATTERY_FACTORY"
    ) {}
}
