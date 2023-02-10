// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {LinkTokenInterface} from "chainlink/interfaces/LinkTokenInterface.sol";
import {VRFCoordinatorV2Interface} from "chainlink/interfaces/VRFCoordinatorV2Interface.sol";

import {VRFCoordinatorV2} from "chainlink/VRFCoordinatorV2.sol";

import {Randomness} from "../../../src/randomness/Randomness.sol";
import {RandomnessStorage} from "../../../src/randomness/RandomnessStorage.sol";

import {VrfConsumerSetUp} from "./VrfConsumerSetUp.sol";
import {VRFConsumerHelper} from "../helpers/VRFConsumerHelper.sol";

contract RandomnessSetUp is VrfConsumerSetUp, VRFConsumerHelper {
    address SUBSCRIPTION_OWNER = 0xE1BE0074E0347DDff1e49eE220d828cB21d1551C;

    Randomness public lottery;
    RandomnessStorage.VRFConsumerSetUp public defaultSetup;
    VRFCoordinatorV2 vrfCoordinator;
    LinkTokenInterface public LINK =
        LinkTokenInterface(0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06);

    event RequestSent(uint256 indexed requestId, uint32 indexed numWords);
    event RequestFulfilled(uint256 indexed requestId, uint256[] randomWords);

    function setUp() public virtual {
        _instanciateFacets();
        _registerFacetAddressesAndNames();
        _createFacetCutFromFacetsAddressFacetsName();
        _triggerDiamondCut();

        defaultSetup = RandomnessStorage.VRFConsumerSetUp({
            COORDINATOR: VRFCoordinatorV2Interface(
                0x6A2AAd07396B36Fe02a22b33cf443582f682c82f
            ), // bsc testnet
            s_subscriptionId: 2506,
            keyHash: 0xd4bb89654db74673a187bd804519e65e3f71a52bc55f11da7601a13dcf505314,
            callbackGasLimit: 100_000,
            requestConfirmations: 3,
            numWords: 2
        });

        vrfCoordinator = VRFCoordinatorV2(address(defaultSetup.COORDINATOR));

        Randomness(address(diamond)).initialize(defaultSetup);
    }

    /**
     * @dev `VrfConsumerSetUp._instanciateFacets()` instanciate
     *      `VrfConsumer` contract.
     */
    function _instanciateFacets() internal override {
        VrfConsumerSetUp._instanciateFacets();
        // deploy RandomnessFaceFacet
        lottery = new Randomness();
    }

    /**
     * @dev Overrides `VrfConsumerSetUp._registerFacetAddressesAndNames`
     *      without calling previous implementation as it does not exist in
     *      `VrfConsumerSetUp`.
     */
    function _registerFacetAddressesAndNames() internal override {
        facetsAddress.push(address(lottery));
        facetsName.push("Randomness");
    }

    function _setDiamondAsVRFConsumer() internal {
        _setDiamondAsVRFConsumer(
            LINK,
            SUBSCRIPTION_OWNER,
            vrfCoordinator,
            defaultSetup.s_subscriptionId,
            address(lottery)
        );
    }
}
