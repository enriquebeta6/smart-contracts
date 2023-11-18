// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ToysLegendCoin is ERC20 {
    address public rewardAddress;
    address public marketingAddress;
    address public operationsAddress;
    address public dynamicFlowAdress;
    address public developmentAddress;

    constructor(
        address _rewardAddress,
        address _marketingAddress,
        address _operationsAddress,
        address _dynamicFlowAdress,
        address _developmentAddress
    ) ERC20("Toys Legend Coin", "TLC") {
        rewardAddress = _rewardAddress;
        marketingAddress = _marketingAddress;
        operationsAddress = _operationsAddress;
        dynamicFlowAdress = _dynamicFlowAdress;
        developmentAddress = _developmentAddress;

        _mint(rewardAddress, 35_000_000 ether);
        _mint(marketingAddress, 1_000_000 ether);
        _mint(operationsAddress, 5_000_000 ether);
        _mint(dynamicFlowAdress, 5_000_000 ether);
        _mint(developmentAddress, 4_000_000 ether);
    }
}
