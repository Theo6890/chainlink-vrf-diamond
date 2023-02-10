// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Counters} from "openzeppelin-contracts/utils/Counters.sol";

// interfaces
import {IRandomnessWritable} from "./IRandomnessWritable.sol";
// contracts
import {RandomnessStorage} from "../RandomnessStorage.sol";
import {RandomnessWritableInternal} from "./RandomnessWritableInternal.sol";

abstract contract RandomnessWritable is
    IRandomnessWritable,
    RandomnessWritableInternal
{
    /// @dev Compulsory to use `RandomnessStorage.layout().id`
    using Counters for Counters.Counter;

    function transformRandomsToMatchRange(uint256 requestId, uint256 range)
        external
    {}

    function requestRandomWords() external returns (uint256 requestId) {
        RandomnessStorage.RandomnessStruct storage strg = RandomnessStorage
            .layout();

        requestId = strg.setup.COORDINATOR.requestRandomWords(
            strg.setup.keyHash,
            strg.setup.s_subscriptionId,
            strg.setup.requestConfirmations,
            strg.setup.callbackGasLimit,
            strg.setup.numWords
        );

        strg.s_requests[requestId] = RandomnessStorage.RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false
        });

        strg.ids.requestIds.push(requestId);
        strg.ids.lastRequestId = requestId;

        emit RequestSent(requestId, strg.setup.numWords);
    }
}
