// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import {LinkTokenInterface} from "chainlink/interfaces/LinkTokenInterface.sol";

import {VRFCoordinatorV2} from "chainlink/VRFCoordinatorV2.sol";

contract VRFConsumerHelper is Test {
    function _sendFiveLINKToVRFCoordinator(
        LinkTokenInterface LINK,
        address SUBSCRIPTION_OWNER,
        address vrfCoordinatorAddr,
        uint64 subId
    ) internal {
        deal(address(LINK), SUBSCRIPTION_OWNER, 5 ether);

        LINK.transferAndCall(vrfCoordinatorAddr, 5 ether, abi.encode(subId));
    }

    function _setDiamondAsVRFConsumer(
        LinkTokenInterface LINK,
        address SUBSCRIPTION_OWNER,
        VRFCoordinatorV2 vrfCoordinator,
        uint64 subId,
        address lottery
    ) internal {
        _sendFiveLINKToVRFCoordinator(
            LINK,
            SUBSCRIPTION_OWNER,
            address(vrfCoordinator),
            subId
        );

        vrfCoordinator.addConsumer(subId, lottery);
    }
}
