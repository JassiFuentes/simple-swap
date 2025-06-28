// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title SimpleSwap
/// @notice Implements basic functionality similar to Uniswap for token swapping and liquidity management
contract SimpleSwap is ERC20 {
    uint private constant FEE_PERCENT = 3; // 0.3% fee (3/1000)

    address public tokenA;
    address public tokenB;

    uint public reserveA;
    uint public reserveB;

    constructor(address _tokenA, address _tokenB) ERC20("Simple LP Token", "SLP") {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    /// @notice Add liquidity to the pool
    function addLiquidity(
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity) {
        require(block.timestamp <= deadline, "Transaction expired");

        if (reserveA == 0 && reserveB == 0) {
            amountA = amountADesired;
            amountB = amountBDesired;
        } else {
            uint amountBOptimal = (amountADesired * reserveB) / reserveA;
            if (amountBOptimal <= amountBDesired) {
                require(amountBOptimal >= amountBMin, "Insufficient B amount");
                amountA = amountADesired;
                amountB = amountBOptimal;
            } else {
                uint amountAOptimal = (amountBDesired * reserveA) / reserveB;
                require(amountAOptimal >= amountAMin, "Insufficient A amount");
                amountA = amountAOptimal;
                amountB = amountBDesired;
            }
        }

        IERC20(tokenA).transferFrom(msg.sender, address(this), amountA);
        IERC20(tokenB).transferFrom(msg.sender, address(this), amountB);

        liquidity = totalSupply() == 0
            ? sqrt(amountA * amountB)
            : min((amountA * totalSupply()) / reserveA, (amountB * totalSupply()) / reserveB);

        _mint(to, liquidity);

        reserveA += amountA;
        reserveB += amountB;
    }

    /// @notice Remove liquidity from the pool
    function removeLiquidity(
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB) {
        require(block.timestamp <= deadline, "Transaction expired");

        uint total = totalSupply();
        amountA = (liquidity * reserveA) / total;
        amountB = (liquidity * reserveB) / total;

        require(amountA >= amountAMin, "Insufficient A output");
        require(amountB >= amountBMin, "Insufficient B output");

        _burn(msg.sender, liquidity);

        IERC20(tokenA).transfer(to, amountA);
        IERC20(tokenB).transfer(to, amountB);

        reserveA -= amountA;
        reserveB -= amountB;
    }

    /// @notice Swap tokens along a path (A -> B or B -> A)
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts) {
        require(path.length == 2, "Only direct swaps supported");
        require(block.timestamp <= deadline, "Transaction expired");

        address input = path[0];
        address output = path[1];
        require((input == tokenA && output == tokenB) || (input == tokenB && output == tokenA), "Invalid token pair");

        (uint reserveIn, uint reserveOut) = input == tokenA ? (reserveA, reserveB) : (reserveB, reserveA);

        IERC20(input).transferFrom(msg.sender, address(this), amountIn);

        uint amountInWithFee = amountIn * (1000 - FEE_PERCENT) / 1000;
        uint amountOut = getAmountOut(amountInWithFee, reserveIn, reserveOut);

        require(amountOut >= amountOutMin, "Insufficient output amount");

        IERC20(output).transfer(to, amountOut);

        if (input == tokenA) {
            reserveA += amountIn;
            reserveB -= amountOut;
        } else {
            reserveB += amountIn;
            reserveA -= amountOut;
        }

        amounts = new uint[](2);
        amounts[0] = amountIn;
        amounts[1] = amountOut;
    }

    /// @notice Get the price of tokenA in terms of tokenB
    function getPrice(address _tokenA, address _tokenB) external view returns (uint price) {
        require((_tokenA == tokenA && _tokenB == tokenB) || (_tokenA == tokenB && _tokenB == tokenA), "Invalid pair");

        if (_tokenA == tokenA) {
            price = (reserveB * 1e18) / reserveA;
        } else {
            price = (reserveA * 1e18) / reserveB;
        }
    }

    /// @notice Get amount of tokens out for a given input and reserves
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) public pure returns (uint amountOut) {
        require(amountIn > 0, "Insufficient input");
        require(reserveIn > 0 && reserveOut > 0, "Insufficient liquidity");

        amountOut = (amountIn * reserveOut) / (reserveIn + amountIn);
    }

    /// @notice Returns the minimum of two numbers
    function min(uint x, uint y) private pure returns (uint) {
        return x < y ? x : y;
    }

    /// @notice Calculates square root using Babylonian method
    function sqrt(uint y) private pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}