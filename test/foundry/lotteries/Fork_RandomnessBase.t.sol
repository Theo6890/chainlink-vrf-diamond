// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Randomness} from "../../../src/randomness/Randomness.sol";

import {RandomnessSetUp} from "../setUp/RandomnessSetUp.sol";

/**
 * @dev Test everything from `RandomnessBase` while foring a network for ALL
 *      tests.
 */
contract Fork_RandomnessBaseTest is RandomnessSetUp {
    /// @dev caching block to fork allows to ping selected network faster
    uint256 cachedAtBlock = 27059317; // Feb-08-2023 12:30:15 PM UTC
    uint64 subscriptionId;

    function setUp() public override {
        vm.createSelectFork(
            "https://data-seed-prebsc-1-s1.binance.org:8545",
            cachedAtBlock
        );

        super.setUp();
        lottery = Randomness(address(diamond));
        subscriptionId = defaultSetup.s_subscriptionId;
    }

    /*//////////////////////////////////////////////////////////////
                            VRFConsumer CONFIG
    //////////////////////////////////////////////////////////////*/
    function testFork_VRFConsumer_CheckSavedValues() public {
        vm.startPrank(SUBSCRIPTION_OWNER);

        (uint96 oldVRFBalance, , , ) = vrfCoordinator.getSubscription(
            subscriptionId
        );

        _setDiamondAsVRFConsumer();

        (
            uint96 balance,
            ,
            address owner,
            address[] memory consumers
        ) = vrfCoordinator.getSubscription(subscriptionId);

        assertEq(balance, oldVRFBalance + 5 ether);
        assertEq(owner, SUBSCRIPTION_OWNER);
        assertEq(consumers[consumers.length - 1], address(lottery));
    }

    /*//////////////////////////////////////////////////////////////
                            RANDOMNESS REQUEST
    //////////////////////////////////////////////////////////////*/
    function testFork_requestRandomWords_CheckRequestStatus() public {
        vm.startPrank(SUBSCRIPTION_OWNER);
        _setDiamondAsVRFConsumer();

        /**
         * @dev We do not check the first parameter `requestId` as we can't easily
         *      compute the value before the request is sent
         */
        vm.expectEmit(false, true, true, true);
        emit RequestSent(0, defaultSetup.numWords);
        uint256 requestId = lottery.requestRandomWords();

        assertEq(requestId, lottery.lastRequestId());
        (bool fulfilled, uint256[] memory randomWords) = lottery.requestStatus(
            requestId
        );
        assertFalse(fulfilled);
        assertEq(randomWords.length, 0);
    }
}
