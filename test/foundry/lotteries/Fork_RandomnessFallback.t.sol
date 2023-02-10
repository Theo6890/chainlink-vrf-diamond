// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Randomness} from "../../../src/randomness/Randomness.sol";

import {RandomnessSetUp} from "../setUp/RandomnessSetUp.sol";

/**
 * @dev Test everything from `RandomnessBase` while foring a network for ALL
 *      tests.
 */
contract Fork_RandomnessFallbackTest is RandomnessSetUp {
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
                            RANDOMNESS ANSWER (fallback)
    //////////////////////////////////////////////////////////////*/
    function testFork_fulfillRandomWords_MockRandomWords_WithEvent_RequestFulfilled()
        public
    {
        vm.startPrank(SUBSCRIPTION_OWNER);

        _setDiamondAsVRFConsumer();

        uint256 requestId = lottery.requestRandomWords();

        /**
         * @dev prank VRF Coordinator, as only it, can call
         *      `lottery.rawFulfillRandomWords`.
         */
        changePrank(address(vrfCoordinator));

        uint256[] memory mockedRandom = new uint256[](2);
        mockedRandom[0] = 7840976015309888952024153810386146845723677169316;
        mockedRandom[1] = 8853282441389336275419091750788016415933652605507;

        vm.expectEmit(true, true, true, true);
        emit RequestFulfilled(requestId, mockedRandom);
        /**
         * @dev external function to fulfill random words, which calls
         *      internal function `fulfillRandomWords`.
         */
        lottery.rawFulfillRandomWords(requestId, mockedRandom);

        (bool fulfilled, uint256[] memory randomWords) = lottery.requestStatus(
            requestId
        );

        assertTrue(fulfilled);
        assertEq(randomWords.length, 2);
    }
}
