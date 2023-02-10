// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Counters} from "openzeppelin-contracts/utils/Counters.sol";

import {RandomnessStorage} from "../RandomnessStorage.sol";

abstract contract RandomnessWritableInternal {
    /// @dev Compulsory to use `RandomnessStorage.layout().id`
    using Counters for Counters.Counter;

    function _init(RandomnessStorage.VRFConsumerSetUp memory setup) internal {
        _setUpVRF(setup);
        _incrementRandomnessId();
        _setState(RandomnessStorage.LOTTERY_STATE.CLOSED);
    }

    function _setUpVRF(RandomnessStorage.VRFConsumerSetUp memory setup)
        internal
    {
        RandomnessStorage.layout().setup = setup;
    }

    function _incrementRandomnessId() internal {
        RandomnessStorage.layout().id.increment();
    }

    function _setState(RandomnessStorage.LOTTERY_STATE state) internal {
        RandomnessStorage.layout().state = state;
    }
}
