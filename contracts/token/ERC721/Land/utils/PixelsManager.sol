// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "hardhat/console.sol";

contract PixelsManager {
    // y => x => tokenId[]
    mapping(
        int => mapping(
            uint => uint[11]
        )
    ) private _landsByYAndX;

    // y => x => counter of added lands
    mapping(int => mapping(uint => uint)) private _addedLands;

    // y => x => position => isAvailable?
    mapping(
        int => mapping(
            uint => mapping(
                uint => bool
            )
        )
    ) private _positions;

    // y => x => isBlocked
    mapping(int => mapping(uint => bool)) private _blockedPixels;

    uint public size;
    uint public buyLimitPerPixel;

    event LandAdded(int y, uint x, uint tokenId, uint position);

    constructor(uint _size, uint _buyLimitPerPixel) {
        size = _size;
        buyLimitPerPixel = _buyLimitPerPixel;

        // Block black pixels
        _blockPixel(-1, 1);
        _blockPixel(-1, 2);
        _blockPixel(-1, 18);
        _blockPixel(-1, 22);
        _blockPixel(-2, 1);
        _blockPixel(-5, 22);
        _blockPixel(-5, 26);
        _blockPixel(-9, 9);
        _blockPixel(-9, 18);
        _blockPixel(-9, 26);
        _blockPixel(-18, 1);
        _blockPixel(-18, 9);
        _blockPixel(-18, 18);
        _blockPixel(-22, 1);
        _blockPixel(-22, 5);
        _blockPixel(-25, 26);
        _blockPixel(-26, 5);
        _blockPixel(-26, 9);
        _blockPixel(-26, 25);
        _blockPixel(-26, 26);

        // Block bank pixels
        _blockPixel(-13, 13);
        _blockPixel(-13, 14);
        _blockPixel(-14, 13);
        _blockPixel(-14, 14);
    }

    function isPixelBlocked(
        int y,
        uint x
    ) public view returns (bool) {
        return _blockedPixels[y][x];
    }

    function isPixelAvailable(
        int y,
        uint x
    ) public view returns (bool) {
        uint counter = _addedLands[y][x];

        return counter != buyLimitPerPixel;
    }

    function isValidPixel(int y, uint x) public view returns (bool) {
        bool xInRange = x > 0 && x <= size;
        bool yInRange = y >= (int(size) * -1) && y < 0;

        return xInRange && yInRange;
    }

    function isPositionAvailable(
        int y,
        uint x,
        uint position
    ) public view returns (bool) {
        return !_positions[y][x][position];
    }

    function _blockPixel(int y, uint x) internal {
        _blockedPixels[y][x] = true;
    }

    function _addLandToPixel(
        int y,
        uint x,
        uint tokenId,
        uint position
    ) internal {
        require(
            !isPixelBlocked(y, x),
            "Pixel's blocked"
        );

        require(
            isValidPixel(y, x),
            "Pixel isn't valid"
        );

        require(
            isPositionAvailable(y, x, position),
            "Position isn't available"
        );

        uint[11] storage _lands = _landsByYAndX[y][x];

        _addedLands[y][x] += 1;
        _lands[position] = tokenId;
        _landsByYAndX[y][x] = _lands;
        _positions[y][x][position] = true;

        if (_addedLands[y][x] > buyLimitPerPixel) {
            require(
                isPixelAvailable(y, x),
                "Pixel isn't available"
            );
        }

        emit LandAdded(y, x, tokenId, position);
    }
}
