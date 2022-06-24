// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./utils/NFTSalePrices.sol";
import "./utils/NFTSaleQuantities.sol";
import "../../token/ERC721/Land/Land.sol";
import "../../token/ERC721/ToysLegendERC721.sol";
import "../../utils/access/ToysLegendAccessControl.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFTSale is
    Pausable,
    NFTSalePrices,
    NFTSaleQuantities,
    ToysLegendAccessControl
{
    IERC20 public busd;
    address public wallet;
    bool public whitelistOnly = true;

    mapping(string => address) public NFTAddresses;

    struct LandsToBuyFromPixel {
        int y;
        uint x;
        uint[] positions;
    }

    struct Item {
        string nft;
        uint variation;
        uint quantity;
    }

    event ItemMinted(
        address indexed buyer,
        address indexed nft,
        uint256 variation,
        uint256 indexed tokenId
    );

    event WhitelistOnlyChange(bool whitelistOnly);

    constructor(
        address _wallet,
        address _busd,
        address _toy,
        address _card,
        address _land,
        address _skin,
        address _weapon,
        address _munitionFactory,
        address _batteryFactory,
        address _market
    ) NFTSalePrices() NFTSaleQuantities() {
        // Set wallet
        wallet = _wallet;

        // Set the BUSD contract
        busd = IERC20(_busd);

        // Set the contract address for each item type.
        setNFTAddress("LAND", _land);
        setNFTAddress("CARD", _card);
        setNFTAddress("SKIN", _skin);
        setNFTAddress("TOY", _toy);
        setNFTAddress("WEAPON", _weapon);
        setNFTAddress("MUNITION_FACTORY", _munitionFactory);
        setNFTAddress("BATTERY_FACTORY", _batteryFactory);
        setNFTAddress("MARKET", _market);
    }

    function setWhitelistOnly(
        bool value
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        whitelistOnly = value;

        emit WhitelistOnlyChange(value);
    }

    function setPriceByNFTAndVariation(
        string memory nft,
        uint variation,
        uint price
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _setPriceByNFTAndVariation(nft, variation, price);
    }

    function setNFTAddress(
        string memory nft,
        address _address
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(_address != address(0), "NFTSale: can't be zero address");

        NFTAddresses[nft] = _address;
    }

    function setMaxQuantityByNFTAndVariation(
        string memory nft,
        uint variation,
        uint maxQuantity
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _setMaxQuantityByNFTAndVariation(nft, variation, maxQuantity);
    }

    function getTotalPriceFromItems(
        Item[] calldata items
    ) public view returns(uint) {
        uint totalPrice = 0;

        for (uint i = 0; i < items.length; i++) {
            Item calldata _item = items[i];

            uint _price = priceByNFTAndVariation[_item.nft][_item.variation];

            require(
                _price > 0,
                "NFTSale: price must be greater than 0"
            );

            totalPrice += _item.quantity * _price;
        }

        return totalPrice;
    }

    function getTotalPriceFromLands(
        LandsToBuyFromPixel[] calldata pixels
    ) public view returns(uint) {
        uint totalPrice = 0;

        for (uint i = 0; i < pixels.length; i++) {
            LandsToBuyFromPixel calldata _pixel = pixels[i];

            uint _variation = _findLandVariation(_pixel);
            uint _price = priceByNFTAndVariation["LAND"][_variation];

            require(
                _price > 0,
                "NFTSale: price must be greater than 0"
            );

            totalPrice += _pixel.positions.length * _price;
        }

        return totalPrice;
    }

    function validateItems(
        Item[] calldata items
    ) public view {
        string[] memory nfts = new string[](items.length);
        uint[] memory quantityCounter = new uint[](items.length);

        for (uint i = 0; i < items.length; i++) {
            Item calldata _item = items[i];

            require(
                _item.quantity > 0,
                "NFTSale: item quantity can't be 0"
            );

            require(
                NFTAddresses[_item.nft] != address(0),
                "NFTSale: not found NFT address"
            );

            require(
                keccak256(abi.encodePacked(_item.nft)) !=
                keccak256(abi.encodePacked("LAND")),
                "NFTSale: only items, not LANDs"
            );

            uint _price = priceByNFTAndVariation[_item.nft][_item.variation];

            require(
                _price > 0,
                "NFTSale: price must be greater than 0"
            );
        }

        for (uint i = 0; i < items.length; i++) {
            Item calldata _item = items[i];

            if (!isMaxQuantityShared(_item.nft)) continue;

            for (uint j = 0; j < nfts.length; j++) {
                if (
                    keccak256(abi.encodePacked(nfts[j])) ==
                    keccak256(abi.encodePacked(_item.nft))
                ) {
                    quantityCounter[j] += _item.quantity;
                }
            }

            nfts[i] = _item.nft;
            quantityCounter[i] += _item.quantity;
        }

        string memory emptyString;

        for (uint i = 0; i < nfts.length; i++) {
            if (
                keccak256(abi.encodePacked(nfts[i])) ==
                keccak256(abi.encodePacked(emptyString))
            ) continue;

            uint quantity = quantityCounter[i];

            require(
                hasAvailableQuantity(nfts[i], 0, quantity),
                string(abi.encodePacked(
                    "NFTSale: ",
                    nfts[i],
                    " must be specified"
                ))
            );
        }
    }

    function validateBalance(
        address buyer,
        uint totalPrice
    ) public view {
        uint256 balance = busd.balanceOf(buyer);

        require(balance >= totalPrice, "NFTSale: not enough BUSD");
    }

    function buyItems(
        Item[] calldata items
    ) public whenNotPaused {
        address _buyer = msg.sender;

        if (whitelistOnly == true) {
            require(
                whitelist.isWhitelisted(_buyer),
                "NFTSale: only whitelisted users"
            );
        }

        uint _totalPrice = getTotalPriceFromItems(items);

        validateItems(items);
        validateBalance(_buyer, _totalPrice);

        require(
            busd.transferFrom(msg.sender, wallet, _totalPrice),
            "NFTSale: failed to transfer BUSD"
        );

        for (uint i = 0; i < items.length; i++) {
            Item calldata _item = items[i];

            address _contractAddress = NFTAddresses[_item.nft];

            ToysLegendERC721 NFT = ToysLegendERC721(_contractAddress);

            _incrementCurrentQuantityByNFTAndType(
                _item.nft,
                _item.variation,
                _item.quantity
            );

            for (uint j = 0; j < _item.quantity; j++) {
                uint256 _tokenId = NFT.safeMint(_buyer);

                emit ItemMinted(
                    _buyer,
                    _contractAddress,
                    _item.variation,
                    _tokenId
                );
            }
        }
    }

    function buyLands(
        LandsToBuyFromPixel[] calldata pixels
    ) public whenNotPaused {
        address _buyer = msg.sender;

        if (whitelistOnly == true) {
            require(
                whitelist.isWhitelisted(_buyer),
                "NFTSale: only whitelisted users"
            );
        }

        uint _totalPrice = getTotalPriceFromLands(pixels);

        validateBalance(_buyer, _totalPrice);

        require(
            busd.transferFrom(msg.sender, wallet, _totalPrice),
            "NFTSale: failed to transfer BUSD"
        );

        for (uint i = 0; i < pixels.length; i++) {
            LandsToBuyFromPixel calldata _pixel = pixels[i];

            uint _variation = _findLandVariation(_pixel);
            address _contractAddress = NFTAddresses["LAND"];

            Land _landContract = Land(_contractAddress);

            _incrementCurrentQuantityByNFTAndType(
                "LAND",
                _variation,
                _pixel.positions.length
            );

            for (uint j = 0; j < _pixel.positions.length; j++) {
                _landContract.safeMint(
                    _buyer,
                    _pixel.y,
                    _pixel.x,
                    _pixel.positions[j],
                    _variation
                );
            }
        }
    }

    function _findLandVariation(
        LandsToBuyFromPixel calldata pixel
    ) internal view returns(uint) {
        uint _pixelPrice = priceByPixel[pixel.y][pixel.x];

        // Lands
        // 1 - Blue
        // 2 - Cyan
        // 3 - Green
        // 4 - Orange
        // 5 - Pink

        uint _variation = 0;

        uint _bluePrice = priceByNFTAndVariation["LAND"][1];
        uint _cyanPrice = priceByNFTAndVariation["LAND"][2];
        uint _greenPrice = priceByNFTAndVariation["LAND"][3];
        uint _orangePrice = priceByNFTAndVariation["LAND"][4];
        uint _pinkPrice = priceByNFTAndVariation["LAND"][5];

        if (_pixelPrice == _bluePrice) {
            _variation = 1;
        } else if (_pixelPrice == _cyanPrice) {
            _variation = 2;
        } else if (_pixelPrice == _greenPrice) {
            _variation = 3;
        } else if (_pixelPrice == _orangePrice) {
            _variation = 4;
        } else if (_pixelPrice == _pinkPrice) {
            _variation = 5;
        }

        return _variation;
    }
}
