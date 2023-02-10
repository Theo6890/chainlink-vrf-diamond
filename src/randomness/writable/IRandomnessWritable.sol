// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IRandomnessWritable {
    event RequestSent(uint256 indexed requestId, uint32 indexed numWords);

    function transformRandomsToMatchRange(uint256 requestId, uint256 range)
        external;

    /// @dev Assumes the subscription is funded sufficiently.
    function requestRandomWords() external returns (uint256 requestId);
}
