// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IRandomnessReadable {
    function lastRequestId() external view returns (uint256);

    function lotteryId() external view returns (uint256);

    function requestStatus(uint256 requestId)
        external
        view
        returns (bool fulfilled, uint256[] memory randomWords);
}
