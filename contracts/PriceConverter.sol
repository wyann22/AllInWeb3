// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
  function getPrice(AggregatorV3Interface price_contract)
    internal
    view
    returns (uint256)
  {
    (
      ,
      /* uint80 roundID */
      int256 price, /*uint startedAt*/ /*uint timeStamp*/ /*uint80 answeredInRound*/
      ,
      ,

    ) = price_contract.latestRoundData();
    // usd for one eth
    // return 3000.00000000
    return uint256(price * 1e10); // 18 decimals;
  }

  function getConversionRate(
    uint256 _ethAmount,
    AggregatorV3Interface price_contract
  ) internal view returns (uint256) {
    return (getPrice(price_contract) * _ethAmount) / 1e18;
  }
}
