// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./access/ToysLegendWhiteList.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "hardhat/console.sol";

contract ToysLegendDonation is Ownable {
    IERC20 public busd;

    uint public numberOfDonators;
    uint public maxNumberOfDonators;
    uint public minimunContribution;

    address public walletOfDonations;

    mapping(address => bool) public donors;

    ToysLegendWhiteList public whitelist;

    constructor(
        address _busd,
        address _whitelist,
        address _walletOfDonations,
        uint256 _minimunContribution,
        uint256 _maxNumberOfDonators
    ) {
        busd = IERC20(_busd);
        walletOfDonations = _walletOfDonations;
        minimunContribution = _minimunContribution;
        maxNumberOfDonators = _maxNumberOfDonators;
        whitelist = ToysLegendWhiteList(_whitelist);
    }

    event AddedToDonors(address indexed account);

    modifier minimunRequirements() {
        require(msg.sender != address(0), "Not address valid");
        require(!isDonator(msg.sender), "You're a donator");
        require(getBalance() >= minimunContribution, "Not enough money");
        require(numberOfDonators + 1 <= maxNumberOfDonators, "Number of donators limit exceed");
        _;
    }

    function getBalance() public view returns(uint) {
        return busd.balanceOf(msg.sender);
    }

    function isDonator(address _address) public view returns(bool) {
        return donors[_address];
    }

    function makeDonation() external minimunRequirements {
        busd.transferFrom(msg.sender, walletOfDonations, minimunContribution);

        donors[msg.sender] = true;
        numberOfDonators = numberOfDonators + 1;
        whitelist.add(msg.sender);

        emit AddedToDonors(msg.sender);
    }

    function changeMaxNumberOfDonators(uint newMaxNumberOfDonators) external onlyOwner {
        maxNumberOfDonators = newMaxNumberOfDonators;
    }

    function changeMinimunContribution(uint amount) external onlyOwner {
        minimunContribution = amount;
    }

    function returnOwnerToWhitelist() external onlyOwner {
        whitelist.transferOwnership(owner());
    }
}
