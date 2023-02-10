// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {VRFCoordinatorV2Interface} from "chainlink/interfaces/VRFCoordinatorV2Interface.sol";

import {Counters} from "openzeppelin-contracts/utils/Counters.sol";

library RandomnessStorage {
    using Counters for Counters.Counter;

    enum LOTTERY_STATE {
        OPEN,
        CLOSED,
        CALCULATING_WINNER
    }

    struct VRFConsumerSetUp {
        VRFCoordinatorV2Interface COORDINATOR;
        uint64 s_subscriptionId;
        bytes32 keyHash; // Gas lane to use (chainlink subscriptions docs)
        /**
         * @dev Storing each word costs about 20,000 gas. Adjust this limit based on
         *     the selected network, the size of the request and the processing of
         *     the callback request in the `fulfillRandomWords()`.
         */
        uint32 callbackGasLimit;
        uint16 requestConfirmations;
        uint32 numWords; // up to `VRFCoordinatorV2.MAX_NUM_WORDS`
    }

    struct VRFRequestId {
        uint256[] requestIds; // Past requests Id
        uint256 lastRequestId;
    }

    struct RequestStatus {
        bool fulfilled;
        bool exists; // whether a requestId exists
        uint256[] randomWords;
    }

    struct RandomnessStruct {
        VRFConsumerSetUp setup;
        VRFRequestId ids;
        mapping(uint256 => RequestStatus) s_requests;
        Counters.Counter id;
        LOTTERY_STATE state;
        address payable[] players;
    }

    bytes32 constant LOTTERY_0_STORAGE = keccak256("diamond.lottery.0.storage");

    /// @return loteryStruct Common storage mapping accross all vaults implemented by Vault0
    function layout()
        internal
        pure
        returns (RandomnessStruct storage loteryStruct)
    {
        bytes32 position = LOTTERY_0_STORAGE;
        assembly {
            loteryStruct.slot := position
        }
    }
}
