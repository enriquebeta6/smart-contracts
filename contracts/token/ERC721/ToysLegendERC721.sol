// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../../utils/access/ToysLegendAccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract ToysLegendERC721 is ERC721Enumerable, Pausable, ToysLegendAccessControl {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    string private _baseTokenURI;

    constructor(
        string memory name,
        string memory symbol,
        string memory _type
    ) ERC721(name, symbol) {
        _baseTokenURI = string(abi.encodePacked(
            "https://oz4hiyqrtfhs.usemoralis.com:2053/server/functions/getNFT?_ApplicationId=btfDRKyFGrZRsV8SRbJmOx0U4W4SqGfd3M4WbD2J&type=",
            _type,
            "&tokenId="
        ));
    }

    function pause() public onlyRole(PAUSER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    function safeMint(address to) public onlyRole(MINTER_ROLE) returns(uint256) {
        uint256 tokenId = _tokenIdCounter.current();

        _tokenIdCounter.increment();
        _safeMint(to, tokenId);

        return tokenId;
    }

    function burn(uint256 tokenId) public onlyRole(BURNER_ROLE) {
        _burn(tokenId);
    }

    function setBaseTokenURI(
        string memory baseTokenURI
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _baseTokenURI = baseTokenURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override
    {
        require(
            hasRole(TRANSFER_ROLE, msg.sender),
            "ToysLegendERC721: only accounts with the TRANSFER_ROLE can transfer tokens"
        );

        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Enumerable, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
