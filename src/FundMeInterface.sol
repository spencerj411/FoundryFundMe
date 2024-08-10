// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

interface FundMeInterface {
    function fund() external payable;

    function getVersion() external view returns (uint256);

    function withdraw() external;

    function cheaperWithdraw() external;

    function i_owner() external view returns (address);

    function MINIMUM_USD() external pure returns (uint256);

    function getAmountFunded(address _address) external view returns (uint256);

    function getFunder(uint256 index) external view returns (address);
}
