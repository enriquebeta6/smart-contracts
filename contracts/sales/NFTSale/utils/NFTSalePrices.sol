// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract NFTSalePrices {
    mapping(string => mapping(uint => uint)) public priceByNFTAndVariation;

    // y => x => price
    mapping(
        int => mapping(
            uint => uint
        )
    ) public priceByPixel;

    uint[26][26] private _bluePixels;
    uint[26][26] private _cyanPixels;
    uint[26][26] private _greenPixels;
    uint[26][26] private _orangePixels;
    uint[26][26] private _pinkPixels;

    constructor() {
        _setPriceByNFTAndVariation(
            "TOY",
            1,
            100 * 10 ** 18
        );

        // Skin
        _setPriceByNFTAndVariation(
            "SKIN",
            1,
            50 * 10 ** 18
        );

        // Weapons
        // 1 - Glock
        // 2 - SHERIFF
        // 3 - UZI
        // 4 - SHORTY
        // 5 - P90
        // 6 - AKA47
        // 7 - SKAR
        // 8 - BARRET
        // 9 - GRENADE LAUNCHER
        // 10 - BAZOOKA
        uint[10] memory weaponPrices = [
            uint(5),
            uint(15),
            uint(20),
            uint(35),
            uint(55),
            uint(70),
            uint(90),
            uint(150),
            uint(210),
            uint(400)
        ];

        for (uint i = 0; i < weaponPrices.length; i++) {
            _setPriceByNFTAndVariation(
                "WEAPON",
                i + 1,
                weaponPrices[i] * 10 ** 18
            );
        }

        // Cards
        // 1 - 10 COMMON
        // 11 - 16 RARE
        // 17 - 20 EPIC
        // 21 - 23 PRO
        // 24 LEGENDARY
        // 25 SUPER LEGENDARY
        uint[25] memory cardPrices = [
            uint(5),
            uint(10),
            uint(15),
            uint(20),
            uint(25),
            uint(35),
            uint(45),
            uint(55),
            uint(65),
            uint(75),
            uint(95),
            uint(115),
            uint(135),
            uint(155),
            uint(175),
            uint(195),
            uint(215),
            uint(245),
            uint(280),
            uint(315),
            uint(355),
            uint(395),
            uint(435),
            uint(490),
            uint(600)
        ];

        for (uint i = 0; i < cardPrices.length; i++) {
            _setPriceByNFTAndVariation(
                "CARD",
                i + 1,
                cardPrices[i] * 10 ** 18
            );
        }

        // Lands
        // 1 - Blue
        // 2 - Cyan
        // 3 - Green
        // 4 - Orange
        // 5 - Pink
        uint[5] memory landPrices = [
            uint(1600),
            uint(1800),
            uint(1950),
            uint(2200),
            uint(2400)
        ];

        for (uint i = 0; i < landPrices.length; i++) {
            _setPriceByNFTAndVariation(
                "LAND",
                i + 1,
                landPrices[i] * 10 ** 18
            );
        }

        // MUNITION FACTORY
        // 1 - COMMON
        // 2 - PRO
        // 3 - LEGENDARY
        uint[3] memory plasticFactoryPrices = [
            uint(800),
            uint(1000),
            uint(1200)
        ];

        for (uint i = 0; i < plasticFactoryPrices.length; i++) {
            _setPriceByNFTAndVariation(
                "MUNITION_FACTORY",
                i + 1,
                plasticFactoryPrices[i] * 10 ** 18
            );
        }

        // BATTERY FACTORY
        // 1 - COMMON
        // 2 - PRO
        // 3 - LEGENDARY
        uint[3] memory energyFactoryPrices = [
            uint(800),
            uint(1100),
            uint(1300)
        ];

        for (uint i = 0; i < energyFactoryPrices.length; i++) {
            _setPriceByNFTAndVariation(
                "BATTERY_FACTORY",
                i + 1,
                energyFactoryPrices[i] * 10 ** 18
            );
        }

        // MARKET
        _setPriceByNFTAndVariation(
            "MARKET",
            1,
            1050 ether
        );

        _setBluePixels();
        _setCyanPixels();
        _setGreenPixels();
        _setOrangePixels();
        _setPinkPixels();
    }

    function _setPriceByNFTAndVariation(
        string memory nft,
        uint variation,
        uint price
    ) internal {
        require(price > 0, "NFTPrices: price must be greater than 0");

        priceByNFTAndVariation[nft][variation] = price;
    }

    function _setPriceByPixel(int y, uint x, uint price) internal {
        require(price > 0, "NFTPrices: price must be greater than 0");

        priceByPixel[y][x] = price;
    }

    function _setBluePixels() internal {
        uint _price = priceByNFTAndVariation["LAND"][1];

        priceByPixel[-1][9] = _price;
        priceByPixel[-1][10] = _price;
        priceByPixel[-1][11] = _price;
        priceByPixel[-1][12] = _price;
        priceByPixel[-1][13] = _price;
        priceByPixel[-1][14] = _price;
        priceByPixel[-2][8] = _price;
        priceByPixel[-2][9] = _price;
        priceByPixel[-2][10] = _price;
        priceByPixel[-2][11] = _price;
        priceByPixel[-2][12] = _price;
        priceByPixel[-2][13] = _price;
        priceByPixel[-2][14] = _price;
        priceByPixel[-3][7] = _price;
        priceByPixel[-3][8] = _price;
        priceByPixel[-3][9] = _price;
        priceByPixel[-3][10] = _price;
        priceByPixel[-3][11] = _price;
        priceByPixel[-3][12] = _price;
        priceByPixel[-3][13] = _price;
        priceByPixel[-3][14] = _price;
        priceByPixel[-4][6] = _price;
        priceByPixel[-4][7] = _price;
        priceByPixel[-4][8] = _price;
        priceByPixel[-4][9] = _price;
        priceByPixel[-4][10] = _price;
        priceByPixel[-4][11] = _price;
        priceByPixel[-4][12] = _price;
        priceByPixel[-4][13] = _price;
        priceByPixel[-4][14] = _price;
        priceByPixel[-5][5] = _price;
        priceByPixel[-5][6] = _price;
        priceByPixel[-5][7] = _price;
        priceByPixel[-5][8] = _price;
        priceByPixel[-5][9] = _price;
        priceByPixel[-5][10] = _price;
        priceByPixel[-5][11] = _price;
        priceByPixel[-5][12] = _price;
        priceByPixel[-5][13] = _price;
        priceByPixel[-5][14] = _price;
        priceByPixel[-5][15] = _price;
        priceByPixel[-5][16] = _price;
        priceByPixel[-5][17] = _price;
        priceByPixel[-5][18] = _price;
        priceByPixel[-6][4] = _price;
        priceByPixel[-6][5] = _price;
        priceByPixel[-6][13] = _price;
        priceByPixel[-6][14] = _price;
        priceByPixel[-7][3] = _price;
        priceByPixel[-7][4] = _price;
        priceByPixel[-7][5] = _price;
        priceByPixel[-7][13] = _price;
        priceByPixel[-7][14] = _price;
        priceByPixel[-8][2] = _price;
        priceByPixel[-8][3] = _price;
        priceByPixel[-8][4] = _price;
        priceByPixel[-8][5] = _price;
        priceByPixel[-8][13] = _price;
        priceByPixel[-8][14] = _price;
        priceByPixel[-9][1] = _price;
        priceByPixel[-9][2] = _price;
        priceByPixel[-9][3] = _price;
        priceByPixel[-9][4] = _price;
        priceByPixel[-9][5] = _price;
        priceByPixel[-9][22] = _price;
        priceByPixel[-10][1] = _price;
        priceByPixel[-10][2] = _price;
        priceByPixel[-10][3] = _price;
        priceByPixel[-10][4] = _price;
        priceByPixel[-10][5] = _price;
        priceByPixel[-10][22] = _price;
        priceByPixel[-11][1] = _price;
        priceByPixel[-11][2] = _price;
        priceByPixel[-11][3] = _price;
        priceByPixel[-11][4] = _price;
        priceByPixel[-11][5] = _price;
        priceByPixel[-11][22] = _price;
        priceByPixel[-12][1] = _price;
        priceByPixel[-12][2] = _price;
        priceByPixel[-12][3] = _price;
        priceByPixel[-12][4] = _price;
        priceByPixel[-12][5] = _price;
        priceByPixel[-12][22] = _price;
        priceByPixel[-13][1] = _price;
        priceByPixel[-13][2] = _price;
        priceByPixel[-13][3] = _price;
        priceByPixel[-13][4] = _price;
        priceByPixel[-13][5] = _price;
        priceByPixel[-13][6] = _price;
        priceByPixel[-13][7] = _price;
        priceByPixel[-13][8] = _price;
        priceByPixel[-13][19] = _price;
        priceByPixel[-13][20] = _price;
        priceByPixel[-13][21] = _price;
        priceByPixel[-13][22] = _price;
        priceByPixel[-13][23] = _price;
        priceByPixel[-13][24] = _price;
        priceByPixel[-13][25] = _price;
        priceByPixel[-13][26] = _price;
        priceByPixel[-14][1] = _price;
        priceByPixel[-14][2] = _price;
        priceByPixel[-14][3] = _price;
        priceByPixel[-14][4] = _price;
        priceByPixel[-14][5] = _price;
        priceByPixel[-14][6] = _price;
        priceByPixel[-14][7] = _price;
        priceByPixel[-14][8] = _price;
        priceByPixel[-14][19] = _price;
        priceByPixel[-14][20] = _price;
        priceByPixel[-14][21] = _price;
        priceByPixel[-14][22] = _price;
        priceByPixel[-14][23] = _price;
        priceByPixel[-14][24] = _price;
        priceByPixel[-14][25] = _price;
        priceByPixel[-14][26] = _price;
        priceByPixel[-15][5] = _price;
        priceByPixel[-15][22] = _price;
        priceByPixel[-15][23] = _price;
        priceByPixel[-15][24] = _price;
        priceByPixel[-15][25] = _price;
        priceByPixel[-15][26] = _price;
        priceByPixel[-16][5] = _price;
        priceByPixel[-16][22] = _price;
        priceByPixel[-16][23] = _price;
        priceByPixel[-16][24] = _price;
        priceByPixel[-16][25] = _price;
        priceByPixel[-16][26] = _price;
        priceByPixel[-17][5] = _price;
        priceByPixel[-17][22] = _price;
        priceByPixel[-17][23] = _price;
        priceByPixel[-17][24] = _price;
        priceByPixel[-17][25] = _price;
        priceByPixel[-17][26] = _price;
        priceByPixel[-18][5] = _price;
        priceByPixel[-18][22] = _price;
        priceByPixel[-18][23] = _price;
        priceByPixel[-18][24] = _price;
        priceByPixel[-18][25] = _price;
        priceByPixel[-18][26] = _price;
        priceByPixel[-19][13] = _price;
        priceByPixel[-19][14] = _price;
        priceByPixel[-19][22] = _price;
        priceByPixel[-19][23] = _price;
        priceByPixel[-19][24] = _price;
        priceByPixel[-19][25] = _price;
        priceByPixel[-20][13] = _price;
        priceByPixel[-20][14] = _price;
        priceByPixel[-20][22] = _price;
        priceByPixel[-20][23] = _price;
        priceByPixel[-20][24] = _price;
        priceByPixel[-21][13] = _price;
        priceByPixel[-21][14] = _price;
        priceByPixel[-21][22] = _price;
        priceByPixel[-21][23] = _price;
        priceByPixel[-22][9] = _price;
        priceByPixel[-22][10] = _price;
        priceByPixel[-22][11] = _price;
        priceByPixel[-22][12] = _price;
        priceByPixel[-22][13] = _price;
        priceByPixel[-22][14] = _price;
        priceByPixel[-22][15] = _price;
        priceByPixel[-22][16] = _price;
        priceByPixel[-22][17] = _price;
        priceByPixel[-22][18] = _price;
        priceByPixel[-22][19] = _price;
        priceByPixel[-22][20] = _price;
        priceByPixel[-22][21] = _price;
        priceByPixel[-22][22] = _price;
        priceByPixel[-23][13] = _price;
        priceByPixel[-23][14] = _price;
        priceByPixel[-23][15] = _price;
        priceByPixel[-23][16] = _price;
        priceByPixel[-23][17] = _price;
        priceByPixel[-23][18] = _price;
        priceByPixel[-23][19] = _price;
        priceByPixel[-23][20] = _price;
        priceByPixel[-23][21] = _price;
        priceByPixel[-24][13] = _price;
        priceByPixel[-24][14] = _price;
        priceByPixel[-24][15] = _price;
        priceByPixel[-24][16] = _price;
        priceByPixel[-24][17] = _price;
        priceByPixel[-24][18] = _price;
        priceByPixel[-24][19] = _price;
        priceByPixel[-24][20] = _price;
        priceByPixel[-25][13] = _price;
        priceByPixel[-25][14] = _price;
        priceByPixel[-25][15] = _price;
        priceByPixel[-25][16] = _price;
        priceByPixel[-25][17] = _price;
        priceByPixel[-25][18] = _price;
        priceByPixel[-25][19] = _price;
        priceByPixel[-26][13] = _price;
        priceByPixel[-26][14] = _price;
        priceByPixel[-26][15] = _price;
        priceByPixel[-26][16] = _price;
        priceByPixel[-26][17] = _price;
        priceByPixel[-26][18] = _price;
    }

    function _setCyanPixels() internal {
        uint _price = priceByNFTAndVariation["LAND"][2];

        priceByPixel[-1][7] = _price;
        priceByPixel[-1][8] = _price;
        priceByPixel[-1][15] = _price;
        priceByPixel[-1][26] = _price;
        priceByPixel[-2][6] = _price;
        priceByPixel[-2][7] = _price;
        priceByPixel[-2][15] = _price;
        priceByPixel[-3][5] = _price;
        priceByPixel[-3][6] = _price;
        priceByPixel[-3][15] = _price;
        priceByPixel[-4][4] = _price;
        priceByPixel[-4][5] = _price;
        priceByPixel[-4][15] = _price;
        priceByPixel[-4][16] = _price;
        priceByPixel[-4][17] = _price;
        priceByPixel[-4][18] = _price;
        priceByPixel[-4][19] = _price;
        priceByPixel[-5][3] = _price;
        priceByPixel[-5][4] = _price;
        priceByPixel[-5][19] = _price;
        priceByPixel[-6][2] = _price;
        priceByPixel[-6][3] = _price;
        priceByPixel[-6][6] = _price;
        priceByPixel[-6][7] = _price;
        priceByPixel[-6][8] = _price;
        priceByPixel[-6][9] = _price;
        priceByPixel[-6][10] = _price;
        priceByPixel[-6][11] = _price;
        priceByPixel[-6][12] = _price;
        priceByPixel[-6][15] = _price;
        priceByPixel[-6][16] = _price;
        priceByPixel[-6][17] = _price;
        priceByPixel[-6][18] = _price;
        priceByPixel[-6][19] = _price;
        priceByPixel[-7][1] = _price;
        priceByPixel[-7][2] = _price;
        priceByPixel[-7][6] = _price;
        priceByPixel[-7][12] = _price;
        priceByPixel[-7][15] = _price;
        priceByPixel[-8][1] = _price;
        priceByPixel[-8][6] = _price;
        priceByPixel[-8][12] = _price;
        priceByPixel[-8][15] = _price;
        priceByPixel[-8][21] = _price;
        priceByPixel[-8][22] = _price;
        priceByPixel[-8][23] = _price;
        priceByPixel[-9][6] = _price;
        priceByPixel[-9][12] = _price;
        priceByPixel[-9][13] = _price;
        priceByPixel[-9][14] = _price;
        priceByPixel[-9][15] = _price;
        priceByPixel[-9][21] = _price;
        priceByPixel[-9][23] = _price;
        priceByPixel[-10][6] = _price;
        priceByPixel[-10][21] = _price;
        priceByPixel[-10][23] = _price;
        priceByPixel[-11][6] = _price;
        priceByPixel[-11][21] = _price;
        priceByPixel[-11][23] = _price;
        priceByPixel[-12][6] = _price;
        priceByPixel[-12][7] = _price;
        priceByPixel[-12][8] = _price;
        priceByPixel[-12][9] = _price;
        priceByPixel[-12][18] = _price;
        priceByPixel[-12][19] = _price;
        priceByPixel[-12][20] = _price;
        priceByPixel[-12][21] = _price;
        priceByPixel[-12][23] = _price;
        priceByPixel[-12][24] = _price;
        priceByPixel[-12][25] = _price;
        priceByPixel[-12][26] = _price;
        priceByPixel[-13][9] = _price;
        priceByPixel[-13][18] = _price;
        priceByPixel[-14][9] = _price;
        priceByPixel[-14][18] = _price;
        priceByPixel[-15][1] = _price;
        priceByPixel[-15][2] = _price;
        priceByPixel[-15][3] = _price;
        priceByPixel[-15][4] = _price;
        priceByPixel[-15][6] = _price;
        priceByPixel[-15][7] = _price;
        priceByPixel[-15][8] = _price;
        priceByPixel[-15][9] = _price;
        priceByPixel[-15][18] = _price;
        priceByPixel[-15][19] = _price;
        priceByPixel[-15][20] = _price;
        priceByPixel[-15][21] = _price;
        priceByPixel[-16][4] = _price;
        priceByPixel[-16][6] = _price;
        priceByPixel[-16][21] = _price;
        priceByPixel[-17][4] = _price;
        priceByPixel[-17][6] = _price;
        priceByPixel[-17][21] = _price;
        priceByPixel[-18][4] = _price;
        priceByPixel[-18][6] = _price;
        priceByPixel[-18][12] = _price;
        priceByPixel[-18][13] = _price;
        priceByPixel[-18][14] = _price;
        priceByPixel[-18][15] = _price;
        priceByPixel[-18][21] = _price;
        priceByPixel[-19][4] = _price;
        priceByPixel[-19][5] = _price;
        priceByPixel[-19][6] = _price;
        priceByPixel[-19][12] = _price;
        priceByPixel[-19][15] = _price;
        priceByPixel[-19][21] = _price;
        priceByPixel[-19][26] = _price;
        priceByPixel[-20][12] = _price;
        priceByPixel[-20][15] = _price;
        priceByPixel[-20][21] = _price;
        priceByPixel[-20][25] = _price;
        priceByPixel[-20][26] = _price;
        priceByPixel[-21][8] = _price;
        priceByPixel[-21][9] = _price;
        priceByPixel[-21][10] = _price;
        priceByPixel[-21][11] = _price;
        priceByPixel[-21][12] = _price;
        priceByPixel[-21][15] = _price;
        priceByPixel[-21][16] = _price;
        priceByPixel[-21][17] = _price;
        priceByPixel[-21][18] = _price;
        priceByPixel[-21][19] = _price;
        priceByPixel[-21][20] = _price;
        priceByPixel[-21][21] = _price;
        priceByPixel[-21][24] = _price;
        priceByPixel[-21][25] = _price;
        priceByPixel[-22][8] = _price;
        priceByPixel[-22][23] = _price;
        priceByPixel[-22][24] = _price;
        priceByPixel[-23][8] = _price;
        priceByPixel[-23][9] = _price;
        priceByPixel[-23][10] = _price;
        priceByPixel[-23][11] = _price;
        priceByPixel[-23][12] = _price;
        priceByPixel[-23][22] = _price;
        priceByPixel[-23][23] = _price;
        priceByPixel[-24][12] = _price;
        priceByPixel[-24][21] = _price;
        priceByPixel[-24][22] = _price;
        priceByPixel[-25][12] = _price;
        priceByPixel[-25][20] = _price;
        priceByPixel[-25][21] = _price;
        priceByPixel[-26][1] = _price;
        priceByPixel[-26][12] = _price;
        priceByPixel[-26][19] = _price;
        priceByPixel[-26][20] = _price;
    }

    function _setGreenPixels() internal {
        uint _price = priceByNFTAndVariation["LAND"][3];

        priceByPixel[-1][5] = _price;
        priceByPixel[-1][6] = _price;
        priceByPixel[-1][16] = _price;
        priceByPixel[-1][20] = _price;
        priceByPixel[-1][24] = _price;
        priceByPixel[-1][25] = _price;
        priceByPixel[-2][4] = _price;
        priceByPixel[-2][5] = _price;
        priceByPixel[-2][16] = _price;
        priceByPixel[-2][20] = _price;
        priceByPixel[-2][24] = _price;
        priceByPixel[-2][25] = _price;
        priceByPixel[-2][26] = _price;
        priceByPixel[-3][3] = _price;
        priceByPixel[-3][4] = _price;
        priceByPixel[-3][16] = _price;
        priceByPixel[-3][17] = _price;
        priceByPixel[-3][18] = _price;
        priceByPixel[-3][19] = _price;
        priceByPixel[-3][20] = _price;
        priceByPixel[-3][21] = _price;
        priceByPixel[-3][22] = _price;
        priceByPixel[-3][23] = _price;
        priceByPixel[-3][24] = _price;
        priceByPixel[-3][25] = _price;
        priceByPixel[-3][26] = _price;
        priceByPixel[-4][2] = _price;
        priceByPixel[-4][3] = _price;
        priceByPixel[-4][20] = _price;
        priceByPixel[-4][24] = _price;
        priceByPixel[-5][1] = _price;
        priceByPixel[-5][2] = _price;
        priceByPixel[-5][20] = _price;
        priceByPixel[-5][24] = _price;
        priceByPixel[-6][1] = _price;
        priceByPixel[-6][20] = _price;
        priceByPixel[-6][24] = _price;
        priceByPixel[-7][7] = _price;
        priceByPixel[-7][8] = _price;
        priceByPixel[-7][9] = _price;
        priceByPixel[-7][10] = _price;
        priceByPixel[-7][11] = _price;
        priceByPixel[-7][16] = _price;
        priceByPixel[-7][17] = _price;
        priceByPixel[-7][18] = _price;
        priceByPixel[-7][19] = _price;
        priceByPixel[-7][20] = _price;
        priceByPixel[-7][21] = _price;
        priceByPixel[-7][22] = _price;
        priceByPixel[-7][23] = _price;
        priceByPixel[-7][24] = _price;
        priceByPixel[-7][25] = _price;
        priceByPixel[-7][26] = _price;
        priceByPixel[-8][7] = _price;
        priceByPixel[-8][11] = _price;
        priceByPixel[-8][16] = _price;
        priceByPixel[-8][20] = _price;
        priceByPixel[-8][24] = _price;
        priceByPixel[-9][7] = _price;
        priceByPixel[-9][11] = _price;
        priceByPixel[-9][16] = _price;
        priceByPixel[-9][20] = _price;
        priceByPixel[-9][24] = _price;
        priceByPixel[-10][7] = _price;
        priceByPixel[-10][11] = _price;
        priceByPixel[-10][12] = _price;
        priceByPixel[-10][13] = _price;
        priceByPixel[-10][14] = _price;
        priceByPixel[-10][15] = _price;
        priceByPixel[-10][16] = _price;
        priceByPixel[-10][20] = _price;
        priceByPixel[-10][24] = _price;
        priceByPixel[-11][7] = _price;
        priceByPixel[-11][8] = _price;
        priceByPixel[-11][9] = _price;
        priceByPixel[-11][10] = _price;
        priceByPixel[-11][17] = _price;
        priceByPixel[-11][18] = _price;
        priceByPixel[-11][19] = _price;
        priceByPixel[-11][20] = _price;
        priceByPixel[-11][24] = _price;
        priceByPixel[-11][25] = _price;
        priceByPixel[-11][26] = _price;
        priceByPixel[-12][10] = _price;
        priceByPixel[-12][17] = _price;
        priceByPixel[-13][10] = _price;
        priceByPixel[-13][17] = _price;
        priceByPixel[-14][10] = _price;
        priceByPixel[-14][17] = _price;
        priceByPixel[-15][10] = _price;
        priceByPixel[-15][17] = _price;
        priceByPixel[-16][1] = _price;
        priceByPixel[-16][2] = _price;
        priceByPixel[-16][3] = _price;
        priceByPixel[-16][7] = _price;
        priceByPixel[-16][8] = _price;
        priceByPixel[-16][9] = _price;
        priceByPixel[-16][10] = _price;
        priceByPixel[-16][17] = _price;
        priceByPixel[-16][18] = _price;
        priceByPixel[-16][19] = _price;
        priceByPixel[-16][20] = _price;
        priceByPixel[-17][3] = _price;
        priceByPixel[-17][7] = _price;
        priceByPixel[-17][11] = _price;
        priceByPixel[-17][12] = _price;
        priceByPixel[-17][13] = _price;
        priceByPixel[-17][14] = _price;
        priceByPixel[-17][15] = _price;
        priceByPixel[-17][16] = _price;
        priceByPixel[-17][20] = _price;
        priceByPixel[-18][3] = _price;
        priceByPixel[-18][7] = _price;
        priceByPixel[-18][11] = _price;
        priceByPixel[-18][16] = _price;
        priceByPixel[-18][20] = _price;
        priceByPixel[-19][3] = _price;
        priceByPixel[-19][7] = _price;
        priceByPixel[-19][11] = _price;
        priceByPixel[-19][16] = _price;
        priceByPixel[-19][20] = _price;
        priceByPixel[-20][1] = _price;
        priceByPixel[-20][2] = _price;
        priceByPixel[-20][3] = _price;
        priceByPixel[-20][4] = _price;
        priceByPixel[-20][5] = _price;
        priceByPixel[-20][6] = _price;
        priceByPixel[-20][7] = _price;
        priceByPixel[-20][8] = _price;
        priceByPixel[-20][9] = _price;
        priceByPixel[-20][10] = _price;
        priceByPixel[-20][11] = _price;
        priceByPixel[-20][16] = _price;
        priceByPixel[-20][17] = _price;
        priceByPixel[-20][18] = _price;
        priceByPixel[-20][19] = _price;
        priceByPixel[-20][20] = _price;
        priceByPixel[-21][3] = _price;
        priceByPixel[-21][7] = _price;
        priceByPixel[-21][26] = _price;
        priceByPixel[-22][3] = _price;
        priceByPixel[-22][7] = _price;
        priceByPixel[-22][25] = _price;
        priceByPixel[-22][26] = _price;
        priceByPixel[-23][3] = _price;
        priceByPixel[-23][7] = _price;
        priceByPixel[-23][24] = _price;
        priceByPixel[-23][25] = _price;
        priceByPixel[-24][1] = _price;
        priceByPixel[-24][2] = _price;
        priceByPixel[-24][3] = _price;
        priceByPixel[-24][4] = _price;
        priceByPixel[-24][5] = _price;
        priceByPixel[-24][6] = _price;
        priceByPixel[-24][7] = _price;
        priceByPixel[-24][8] = _price;
        priceByPixel[-24][9] = _price;
        priceByPixel[-24][10] = _price;
        priceByPixel[-24][11] = _price;
        priceByPixel[-24][23] = _price;
        priceByPixel[-24][24] = _price;
        priceByPixel[-25][1] = _price;
        priceByPixel[-25][2] = _price;
        priceByPixel[-25][3] = _price;
        priceByPixel[-25][7] = _price;
        priceByPixel[-25][11] = _price;
        priceByPixel[-25][22] = _price;
        priceByPixel[-25][23] = _price;
        priceByPixel[-26][2] = _price;
        priceByPixel[-26][3] = _price;
        priceByPixel[-26][7] = _price;
        priceByPixel[-26][11] = _price;
        priceByPixel[-26][21] = _price;
        priceByPixel[-26][22] = _price;
    }

    function _setOrangePixels() internal {
        uint _price = priceByNFTAndVariation["LAND"][4];

        priceByPixel[-1][3] = _price;
        priceByPixel[-1][4] = _price;
        priceByPixel[-1][17] = _price;
        priceByPixel[-1][19] = _price;
        priceByPixel[-1][21] = _price;
        priceByPixel[-1][23] = _price;
        priceByPixel[-2][2] = _price;
        priceByPixel[-2][3] = _price;
        priceByPixel[-2][17] = _price;
        priceByPixel[-2][18] = _price;
        priceByPixel[-2][19] = _price;
        priceByPixel[-2][21] = _price;
        priceByPixel[-2][22] = _price;
        priceByPixel[-2][23] = _price;
        priceByPixel[-3][1] = _price;
        priceByPixel[-3][2] = _price;
        priceByPixel[-4][1] = _price;
        priceByPixel[-4][21] = _price;
        priceByPixel[-4][22] = _price;
        priceByPixel[-4][23] = _price;
        priceByPixel[-4][25] = _price;
        priceByPixel[-4][26] = _price;
        priceByPixel[-5][21] = _price;
        priceByPixel[-5][23] = _price;
        priceByPixel[-5][25] = _price;
        priceByPixel[-6][21] = _price;
        priceByPixel[-6][22] = _price;
        priceByPixel[-6][23] = _price;
        priceByPixel[-6][25] = _price;
        priceByPixel[-6][26] = _price;
        priceByPixel[-8][8] = _price;
        priceByPixel[-8][9] = _price;
        priceByPixel[-8][10] = _price;
        priceByPixel[-8][17] = _price;
        priceByPixel[-8][18] = _price;
        priceByPixel[-8][19] = _price;
        priceByPixel[-8][25] = _price;
        priceByPixel[-8][26] = _price;
        priceByPixel[-9][8] = _price;
        priceByPixel[-9][10] = _price;
        priceByPixel[-9][17] = _price;
        priceByPixel[-9][19] = _price;
        priceByPixel[-9][25] = _price;
        priceByPixel[-10][8] = _price;
        priceByPixel[-10][9] = _price;
        priceByPixel[-10][10] = _price;
        priceByPixel[-10][17] = _price;
        priceByPixel[-10][18] = _price;
        priceByPixel[-10][19] = _price;
        priceByPixel[-10][25] = _price;
        priceByPixel[-10][26] = _price;
        priceByPixel[-11][11] = _price;
        priceByPixel[-11][12] = _price;
        priceByPixel[-11][13] = _price;
        priceByPixel[-11][14] = _price;
        priceByPixel[-11][15] = _price;
        priceByPixel[-11][16] = _price;
        priceByPixel[-12][11] = _price;
        priceByPixel[-12][16] = _price;
        priceByPixel[-13][11] = _price;
        priceByPixel[-13][16] = _price;
        priceByPixel[-14][11] = _price;
        priceByPixel[-14][16] = _price;
        priceByPixel[-15][11] = _price;
        priceByPixel[-15][16] = _price;
        priceByPixel[-16][11] = _price;
        priceByPixel[-16][12] = _price;
        priceByPixel[-16][13] = _price;
        priceByPixel[-16][14] = _price;
        priceByPixel[-16][15] = _price;
        priceByPixel[-16][16] = _price;
        priceByPixel[-17][1] = _price;
        priceByPixel[-17][2] = _price;
        priceByPixel[-17][8] = _price;
        priceByPixel[-17][9] = _price;
        priceByPixel[-17][10] = _price;
        priceByPixel[-17][17] = _price;
        priceByPixel[-17][18] = _price;
        priceByPixel[-17][19] = _price;
        priceByPixel[-18][2] = _price;
        priceByPixel[-18][8] = _price;
        priceByPixel[-18][10] = _price;
        priceByPixel[-18][17] = _price;
        priceByPixel[-18][19] = _price;
        priceByPixel[-19][1] = _price;
        priceByPixel[-19][2] = _price;
        priceByPixel[-19][8] = _price;
        priceByPixel[-19][9] = _price;
        priceByPixel[-19][10] = _price;
        priceByPixel[-19][17] = _price;
        priceByPixel[-19][18] = _price;
        priceByPixel[-19][19] = _price;
        priceByPixel[-21][1] = _price;
        priceByPixel[-21][2] = _price;
        priceByPixel[-21][4] = _price;
        priceByPixel[-21][5] = _price;
        priceByPixel[-21][6] = _price;
        priceByPixel[-22][2] = _price;
        priceByPixel[-22][4] = _price;
        priceByPixel[-22][6] = _price;
        priceByPixel[-23][1] = _price;
        priceByPixel[-23][2] = _price;
        priceByPixel[-23][4] = _price;
        priceByPixel[-23][5] = _price;
        priceByPixel[-23][6] = _price;
        priceByPixel[-23][26] = _price;
        priceByPixel[-24][25] = _price;
        priceByPixel[-24][26] = _price;
        priceByPixel[-25][4] = _price;
        priceByPixel[-25][5] = _price;
        priceByPixel[-25][6] = _price;
        priceByPixel[-25][8] = _price;
        priceByPixel[-25][9] = _price;
        priceByPixel[-25][10] = _price;
        priceByPixel[-25][24] = _price;
        priceByPixel[-25][25] = _price;
        priceByPixel[-26][4] = _price;
        priceByPixel[-26][6] = _price;
        priceByPixel[-26][8] = _price;
        priceByPixel[-26][10] = _price;
        priceByPixel[-26][23] = _price;
        priceByPixel[-26][24] = _price;
    }

    function _setPinkPixels() internal {
        uint _price = priceByNFTAndVariation["LAND"][5];

        priceByPixel[-12][12] = _price;
        priceByPixel[-12][13] = _price;
        priceByPixel[-12][14] = _price;
        priceByPixel[-12][15] = _price;
        priceByPixel[-13][12] = _price;
        priceByPixel[-13][15] = _price;
        priceByPixel[-14][12] = _price;
        priceByPixel[-14][15] = _price;
        priceByPixel[-15][12] = _price;
        priceByPixel[-15][13] = _price;
        priceByPixel[-15][14] = _price;
        priceByPixel[-15][15] = _price;
    }
}
