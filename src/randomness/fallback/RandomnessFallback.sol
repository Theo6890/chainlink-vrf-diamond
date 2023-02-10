// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {VRFConsumerBaseV2} from "chainlink/VRFConsumerBaseV2.sol";

// interfaces
import {IRandomnessFallback} from "./IRandomnessFallback.sol";
// libraries
import {RandomnessStorage} from "../RandomnessStorage.sol";

abstract contract RandomnessFallback is IRandomnessFallback, VRFConsumerBaseV2 {
    constructor()
        VRFConsumerBaseV2(0x6A2AAd07396B36Fe02a22b33cf443582f682c82f)
    {}

    /**
     * @dev Used by `VRFConsumerBaseV2` to fulfill randomness requests on
     *      fallback.
     */
    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        RandomnessStorage.RandomnessStruct storage strg = RandomnessStorage
            .layout();

        require(strg.s_requests[_requestId].exists, "request not found");
        strg.s_requests[_requestId].fulfilled = true;
        strg.s_requests[_requestId].randomWords = _randomWords;

        emit RequestFulfilled(_requestId, _randomWords);
    }
}
