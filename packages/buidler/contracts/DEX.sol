pragma solidity ^0.6.6;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DEX {
    using SafeMath for uint256;
    IERC20 token;

    constructor(address token_addr) public {
        token = IERC20(token_addr);
    }

    //tracks total liquidity
    uint256 public totalLiquidity;
    //tracks individual addresses
    mapping(address => uint256) public liquidity;

    //Loads contracts with ETH and balloons
    function init(uint256 tokens) public payable returns (uint256) {
        require(totalLiquidity == 0, "DEX:init - already has liquidity");
        totalLiquidity = address(this).balance;
        liquidity[msg.sender] = totalLiquidity;
        require(token.transferFrom(msg.sender, address(this), tokens));
        return totalLiquidity;
    }

    //Pricing a swap
    //We use the ratio of the input vs output reserve to calculate the price to swap either asset for the other.
    function price(
        uint256 input_amount,
        uint256 input_reserve,
        uint256 output_reserve
    ) public view returns (uint256) {
        uint256 input_amount_with_fee = input_amount.mul(997);
        uint256 numerator = input_amount_with_fee.mul(output_reserve);
        uint256 denominator =
            input_reserve.mul(1000).add(input_amount_with_fee);
        return numerator / denominator;
    }

    //Trading
    function ethToToken() public payable returns (uint256) {
        uint256 token_reserve = token.balanceOf(address(this));
        uint256 tokens_bought =
            price(
                msg.value,
                address(this).balance.sub(msg.value),
                token_reserve
            );
        require(token.transfer(msg.sender, tokens_bought));
        return tokens_bought;
    }

    function tokenToEth(uint256 tokens) public returns (uint256) {
        uint256 token_reserve = token.balanceOf(address(this));
        uint256 eth_bought =
            price(tokens, token_reserve, address(this).balance);
        msg.sender.transfer(eth_bought);
        require(token.transferFrom(msg.sender, address(this), tokens));
        return eth_bought;
    }
}
