// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BUSDTokenMock is ERC20 {
    constructor() ERC20("BUSD Token Mock", "BUSD") {
        _mint(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 1000 ether);
        _mint(0x70997970C51812dc3A010C7d01b50e0d17dc79C8, 4000 ether);
        _mint(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 8000 ether);
    }
}
