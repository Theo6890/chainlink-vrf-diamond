// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

interface IRandomnessFallback {
    event RequestFulfilled(uint256 indexed requestId, uint256[] randomWords);
}
