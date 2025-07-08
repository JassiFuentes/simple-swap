// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenA is ERC20 {
    constructor() ERC20("Token A", "TKNA") {
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }
}

contract TokenB is ERC20 {
    constructor() ERC20("Token B", "TKNB") {
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }
}
