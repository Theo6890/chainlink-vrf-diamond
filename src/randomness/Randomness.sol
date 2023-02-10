// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Initializable} from "openzeppelin-contracts/proxy/utils/Initializable.sol";
import {OwnableInternal} from "solidstate-solidity/access/ownable/OwnableInternal.sol";

// libraries
import {RandomnessStorage} from "./RandomnessStorage.sol";
// contracts
import {RandomnessFallback} from "./fallback/RandomnessFallback.sol";
import {RandomnessReadable} from "./readable/RandomnessReadable.sol";
import {RandomnessWritable} from "./writable/RandomnessWritable.sol";

contract Randomness is
    RandomnessFallback,
    RandomnessReadable,
    RandomnessWritable,
    Initializable,
    OwnableInternal
{
    function initialize(RandomnessStorage.VRFConsumerSetUp memory setup)
        external
        initializer
        onlyOwner
    {
        _init(setup);
    }
}
