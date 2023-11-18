// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./ToysLegendBlackList.sol";
import "./ToysLegendWhiteList.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ToysLegendAccessControl is AccessControl {
    // Lists
    ToysLegendWhiteList public whitelist;
    ToysLegendBlackList public blacklist;

    // Roles
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
    bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");

    constructor() {
        _grantRole(PAUSER_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(BURNER_ROLE, msg.sender);
        _grantRole(TRANSFER_ROLE, msg.sender);
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    modifier onlyWhitelisted(address _address) {
        require(whitelist.isWhitelisted(_address), "Only whitelisted users");
        _;
    }

    modifier notBlacklisted(address _address) {
        require(!blacklist.isBlacklisted(_address), "Not blacklisted users");
        _;
    }

    function setWhiteList(address _whitelist) public onlyRole(DEFAULT_ADMIN_ROLE) {
        whitelist = ToysLegendWhiteList(_whitelist);
    }

    function setBlackList(address _blacklist) public onlyRole(DEFAULT_ADMIN_ROLE) {
        blacklist = ToysLegendBlackList(_blacklist);
    }

    function isWhitelisted(address _address) public view returns(bool) {
        return whitelist.isWhitelisted(_address);
    }

    function isBlacklisted(address _address) public view returns(bool) {
        return blacklist.isBlacklisted(_address);
    }
}
