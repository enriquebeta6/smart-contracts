// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract NFTSaleQuantities {
    mapping(string => mapping(uint => uint)) public maxQuantityByNFTAndVariation;
    mapping(string => mapping(uint => uint)) public currentQuantityByNFTAndVariation;

    constructor() {
        // Set the max quantity for each variation.
        // The 0 means all the variations.
        _setMaxQuantityByNFTAndVariation("LAND", 0, 256);
        _setMaxQuantityByNFTAndVariation("WEAPON", 0, 7_500);

        // TOY
        _setMaxQuantityByNFTAndVariation("TOY", 1, 5_000);

        // SKINs
        _setMaxQuantityByNFTAndVariation("SKIN", 1, 2_000);

        // MARKET
        _setMaxQuantityByNFTAndVariation("MARKET", 1, 50);

        // CARDs
        _setMaxQuantityByNFTAndVariation("CARD", 1, 3_335 * 15);
        _setMaxQuantityByNFTAndVariation("CARD", 3, 3_333 * 15);
        _setMaxQuantityByNFTAndVariation("CARD", 4, 3_333 * 15);
        _setMaxQuantityByNFTAndVariation("CARD", 7, 3_333 * 15);
        _setMaxQuantityByNFTAndVariation("CARD", 11, 3_333 * 15);
        _setMaxQuantityByNFTAndVariation("CARD", 18, 3_333 * 15);

        // MUNITION FACTORY
        // 1 - COMMON
        // 2 - PRO
        // 3 - LEGENDARY
        _setMaxQuantityByNFTAndVariation("MUNITION_FACTORY", 1, 40);
        _setMaxQuantityByNFTAndVariation("MUNITION_FACTORY", 2, 30);
        _setMaxQuantityByNFTAndVariation("MUNITION_FACTORY", 3, 20);

        // BATTERY FACTORY
        // 1 - COMMON
        // 2 - PRO
        // 3 - LEGENDARY
        _setMaxQuantityByNFTAndVariation("BATTERY_FACTORY", 1, 40);
        _setMaxQuantityByNFTAndVariation("BATTERY_FACTORY", 2, 30);
        _setMaxQuantityByNFTAndVariation("BATTERY_FACTORY", 3, 20);
    }

    function _setMaxQuantityByNFTAndVariation(
        string memory nft,
        uint variation,
        uint maxQuantity
    ) internal {
        require(
            maxQuantity > 0,
            "NFTQuantities: max quantity must be greater than 0"
        );

        maxQuantityByNFTAndVariation[nft][variation] = maxQuantity;
    }

    function isMaxQuantityShared(
        string memory nft
    ) public view returns(bool) {
        if (maxQuantityByNFTAndVariation[nft][0] > 0) {
            return true;
        }

        return false;
    }

    function _incrementCurrentQuantityByNFTAndType(
        string memory nft,
        uint variation,
        uint quantity
    ) internal {
        uint _tempType = variation;

        if (isMaxQuantityShared(nft)) {
            _tempType = 0;
        }

        require(
            hasAvailableQuantity(nft, _tempType, quantity),
            "NFTQuantities: not enough quantity"
        );

        currentQuantityByNFTAndVariation[nft][variation] += quantity;
    }

    function hasAvailableQuantity(
        string memory nft,
        uint variation,
        uint quantity
    ) public view returns(bool) {
        uint maxQuantity = maxQuantityByNFTAndVariation[nft][variation];
        uint currentQuantity = currentQuantityByNFTAndVariation[nft][variation];

        if (currentQuantity + quantity > maxQuantity) {
            return false;
        }

        return true;
    }
}
