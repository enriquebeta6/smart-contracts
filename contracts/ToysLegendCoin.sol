// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ToysLegendCoin is ERC20 {
    constructor(address _owner) ERC20("Toys Legend Coin", "TLC") {
        _mint(_owner, 50_000_000 ether);
    }
}
