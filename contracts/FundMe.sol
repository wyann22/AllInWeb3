// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";
import "./Imap.sol";
error NotOwner();

contract FundMe {
  using PriceConverter for uint256;
  using IterableMapping for itmap;
  uint256 public minimumUsd = 50 * 1e18;
  itmap public addressToAmountFunded;
  uint256 public funder_count;
  // Apply library functions to the data type.
  address public owner;
  AggregatorV3Interface private price_contract;

  constructor(address priceFeedAddress) {
    price_contract = AggregatorV3Interface(priceFeedAddress);
    owner = msg.sender;
  }

  function fund() public payable {
    require(
      msg.value.getConversionRate(price_contract) >= minimumUsd,
      "Didn't send enough!"
    );
    addressToAmountFunded.insert(
      uint160(msg.sender),
      addressToAmountFunded.get(uint160(msg.sender)) + msg.value
    );
    funder_count = addressToAmountFunded.size;
  }

  modifier onlyOwner() {
    // require(msg.sender == owner);
    if (msg.sender != owner) revert NotOwner();
    _;
  }

  function withdraw() public onlyOwner {
    addressToAmountFunded.reset();
    funder_count = addressToAmountFunded.size;
    (bool callSuccess, ) = payable(msg.sender).call{
      value: address(this).balance
    }("");
    require(callSuccess, "Call failed");
  }

  // Explainer from: https://solidity-by-example.org/fallback/
  // Ether is sent to contract
  //      is msg.data empty?
  //          /   \
  //         yes  no
  //         /     \
  //    receive()?  fallback()
  //     /   \
  //   yes   no
  //  /        \
  //receive()  fallback()

  fallback() external payable {
    fund();
  }

  receive() external payable {
    fund();
  }
}
