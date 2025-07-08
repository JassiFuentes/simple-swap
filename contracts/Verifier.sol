// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Verifier {
    event Verified(
        address indexed swapContract,
        address indexed tokenA,
        address indexed tokenB,
        uint256 amountA,
        uint256 amountB,
        uint256 amountIn,
        string author
    );

    function verify(
        address swapContract,
        address tokenA,
        address tokenB,
        uint256 amountA,
        uint256 amountB,
        uint256 amountIn,
        string memory author
    ) external {
        emit Verified(swapContract, tokenA, tokenB, amountA, amountB, amountIn, author);
    }
}
