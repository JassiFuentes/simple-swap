// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title SimpleSwap
/// @notice Implements basic functionality similar to Uniswap for token swapping and liquidity management
/// @dev Users can provide liquidity, remove it, or perform token swaps. LP tokens are issued to represent shares.
contract SimpleSwap is ERC20 {
    /// @dev Fee applied to swaps, represented as parts per thousand (3 = 0.3%)
    uint private constant FEE_PERCENT = 3;

    /// @notice Address of token A in the pair
    address public tokenA;

    /// @notice Address of token B in the pair
    address public tokenB;

    /// @notice Reserve of token A
    uint public reserveA;

    /// @notice Reserve of token B
    uint public reserveB;

    /// @notice Initializes the contract with token pair
    /// @param _tokenA Address of token A
    /// @param _tokenB Address of token B
    constructor(address _tokenA, address _tokenB) ERC20("Simple LP Token", "SLP") {
        tokenA = _tokenA;
        tokenB = _tokenB;
    }

    /// @notice Adds liquidity to the pool and mints LP tokens
    /// @param amountADesired Desired amount of token A
    /// @param amountBDesired Desired amount of token B
    /// @param amountAMin Minimum amount of token A to accept
    /// @param amountBMin Minimum amount of token B to accept
    /// @param to Recipient of LP tokens
    /// @param deadline Expiration timestamp
    /// @return amountA Final amount of token A added
    /// @return amountB Final amount of token B added
    /// @return liquidity Amount of LP tokens minted
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

    /// @notice Removes liquidity and returns tokens to the user
    /// @param liquidity Amount of LP tokens to burn
    /// @param amountAMin Minimum amount of token A to return
    /// @param amountBMin Minimum amount of token B to return
    /// @param to Recipient of the tokens
    /// @param deadline Expiration timestamp
    /// @return amountA Amount of token A returned
    /// @return amountB Amount of token B returned
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

    /// @notice Swaps a fixed amount of input tokens for output tokens
    /// @param amountIn Amount of input tokens to swap
    /// @param amountOutMin Minimum output tokens acceptable
    /// @param path Array with [inputToken, outputToken]
    /// @param to Address to send output tokens to
    /// @param deadline Expiration timestamp
    /// @return amounts Array with [amountIn, amountOut]
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

        amounts = new uint ;
        amounts[0] = amountIn;
        amounts[1] = amountOut;
    }

    /// @notice Returns the price of tokenA in terms of tokenB or vice versa
    /// @param _tokenA Address of base token
    /// @param _tokenB Address of quote token
    /// @return price Current price as a uint with 18 decimals
    function getPrice(address _tokenA, address _tokenB) external view returns (uint price) {
        require((_tokenA == tokenA && _tokenB == tokenB) || (_tokenA == tokenB && _tokenB == tokenA), "Invalid pair");

        if (_tokenA == tokenA) {
            price = (reserveB * 1e18) / reserveA;
        } else {
            price = (reserveA * 1e18) / reserveB;
        }
    }

    /// @notice Calculates how many tokens will be received in a swap
    /// @param amountIn Amount of input tokens
    /// @param reserveIn Reserve of input token
    /// @param reserveOut Reserve of output token
    /// @return amountOut Calculated output amount
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) public pure returns (uint amountOut) {
        require(amountIn > 0, "Insufficient input");
        require(reserveIn > 0 && reserveOut > 0, "Insufficient liquidity");

        amountOut = (amountIn * reserveOut) / (reserveIn + amountIn);
    }

    /// @notice Returns the smaller of two numbers
    function min(uint x, uint y) private pure returns (uint) {
        return x < y ? x : y;
    }

    /// @notice Calculates square root using the Babylonian method
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
