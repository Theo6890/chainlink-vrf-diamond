# Randomness Module

This module uses Chainlink VRF via [subscription](https://docs.chain.link/vrf/v2/subscription/).

## Guide

Module to:

-   Request a random word via `requestRandomWords()`
-   Map the storage of requests of randoms via `RandomnessStorage.sol`
-   Transform received randoms to match a certain range via `transformRandomsToMatchRange(uint256 requestId, uint256 range)`
    -   The random numbers are expressed on a uint256 which might not be suitable for the app
    -   We can calculate a range based on the randoms received from _0 to n_ by using a modulo on randoms, e.g. `randoms[i] % n`

## TODO

-   `requestRandomWords`:
    -   custom error `RandomnessWritable__SubscriptionNotSufficientlyFunded`
-   `transformRandomsToMatchRange`:
    -   called only once by `requestId`
-   events:
    -   event VRFConsumerSetUp (init)

## To Clarifiy

All good for now
