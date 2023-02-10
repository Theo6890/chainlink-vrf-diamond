// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Counters} from "openzeppelin-contracts/utils/Counters.sol";

// interfaces
import {IRandomnessReadable} from "./IRandomnessReadable.sol";
// libraries
import {RandomnessStorage} from "../RandomnessStorage.sol";

abstract contract RandomnessReadable is IRandomnessReadable {
    /// @dev Compulsory to use `RandomnessStorage.layout().id`
    using Counters for Counters.Counter;

    function lastRequestId() external view returns (uint256) {
        return RandomnessStorage.layout().ids.lastRequestId;
    }

    function lotteryId() external view returns (uint256) {
        return RandomnessStorage.layout().id.current();
    }

    function requestStatus(uint256 requestId)
        external
        view
        returns (bool fulfilled, uint256[] memory randomWords)
    {
        RandomnessStorage.RandomnessStruct storage strg = RandomnessStorage
            .layout();

        fulfilled = strg.s_requests[requestId].fulfilled;
        randomWords = strg.s_requests[requestId].randomWords;
    }
}
