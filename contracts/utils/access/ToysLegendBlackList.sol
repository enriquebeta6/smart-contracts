// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ToysLegendBlackList is Ownable {
    uint256 public blacklistCount;
    mapping(address => bool) public blacklist;

    event AddedToBlacklist(address indexed account);
    event RemovedFromBlacklist(address indexed account);

    function add(address _address) external onlyOwner {
        blacklistCount++;
        blacklist[_address] = true;
        emit AddedToBlacklist(_address);
    }

    function remove(address _address) external onlyOwner {
        blacklistCount--;
        blacklist[_address] = false;
        emit RemovedFromBlacklist(_address);
    }

    function isBlacklisted(address _address) public view returns(bool) {
        return blacklist[_address];
    }
}
