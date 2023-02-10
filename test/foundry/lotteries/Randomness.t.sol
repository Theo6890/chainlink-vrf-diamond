// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Randomness} from "../../../src/randomness/Randomness.sol";

import {RandomnessSetUp} from "../setUp/RandomnessSetUp.sol";

/**
 * @dev Tests `initialize` effects and everything else directly written in
 *      `Randomness`.
 */
contract RandomnessTest is RandomnessSetUp {
    function setUp() public override {
        super.setUp();
        lottery = Randomness(address(diamond));
    }

    /*//////////////////////////////////////////////////////////////
                            LOTTERIES BASICS
    //////////////////////////////////////////////////////////////*/
    function test_defaultRandomnessId() public {
        assertEq(lottery.lotteryId(), 1);
    }

    function test_Revert_initialize_Twice() public {
        vm.expectRevert("Initializable: contract is already initialized");
        Randomness(address(diamond)).initialize(defaultSetup);
    }
}
