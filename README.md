# <h1 align="center"> Chainlink VRF Diamond </h1>

Request Chainlink on-chain randomness following the diamond pattern (ERC-2535) for agile development.

# Diamond Pattern

-   Allows to iterate development on-chain at low cost (including mainnet)
-   Organise app logic into modules with a facet per feature where storage can be shared or unique to the module

## Facet's Storage

A facet can have a specific proxy storage (eternal storage, another diamonds stockage, etc...). This will depend on the evolution of the dApp complexity throught development lifecycle.

## Solidstate Layout

An overview of the uses of each visibility layer is as follows:

| **folder**   | **layer**              | **contents**                                                      | **description**                                                                                                                                                                                                                   | **example**                                                                    |
| ------------ | ---------------------- | ----------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| **-**        | 'internal' `interface` | custom `error`, `enum`, `struct`, `event` & preferably `modifier` | parent of `IXyz.sol`                                                                                                                                                                                                              | `IRandomnessWritableInternal.sol`, `IRandomnessReadableInternal.sol`           |
| **-**        | `interface`            | function prototypes                                               | child of internal interfaces (e.g. `IRandomnessWritable is IRandomnessWritableInternal`)                                                                                                                                          | `IRandomnessFallback.sol`, `IRandomnessReadble.sol`, `IRandomnessWritable.sol` |
| **fallback** | external               | any function visibility                                           | set of functions, which are **only** used when a callback is made to the diamond (e.g. `VRFConsumerBaseV2.fulfillRandomWords`). It can modify and/or read the state, which is why it can be nor in `readable` or `writable` only. | `RandomnessFallback.sol`                                                       |
| **readable** | external               | external or public functions                                      | set of functions that defines a module's getters                                                                                                                                                                                  | `RandomnessReadable.sol`                                                       |
| **writable** | external & internal    | any function visibility                                           | set of functions that defines a module's core logic; internal function always declares as `xyzWritableInternal.sol`                                                                                                               | `RandomnessInternalWritable.sol`, `RandomnessWritable.sol`                     |
| **./**       | storage                | internal library functions, structs                               | library for accessing and modifying storage; useful when sharing access to storage between implementation contracts that will be deployed separately (such as in the "diamond" proxy architecture)                                | `RandomnessStorage.sol`                                                        |

# Versions

TBD

## Common Specifications

TBD

## v0.1.0:

## v0.2.0:

## v0.3.0:

## v1.0.0: Mainnet release

# EIPs To Consider

-   2612: permit (off-chain approval)

# Best Practices to Follow

## Generics

-   Code formatter & linter: prettier, solhint, husky, lint-staged & husky
-   [Foundry](https://book.getfoundry.sh/tutorials/best-practices)

## Security

-   [Solidity Patterns](https://github.com/fravoll/solidity-patterns)
-   [Solcurity Codes](https://github.com/transmissions11/solcurity)
-   Secureum posts _([101](https://secureum.substack.com/p/security-pitfalls-and-best-practices-101) & [101](https://secureum.substack.com/p/security-pitfalls-and-best-practices-201): Security Pitfalls & Best Practice)_
-   [Smart Contract Security Verification Standard](https://github.com/securing/SCSVS)
-   [SWC](https://swcregistry.io)

# Be Prepared For Audits

-   Well refactored & commented code (NatSpec comment & [PlantUML](https://plantuml.com/starting))
-   Unit ([TDD](https://r-code.notion.site/TDDs-steps-cecba0a82ee6466f9f479ca553949be2)) & integration (BDD) tests (green)
-   _Paper code review (architecture & conception tests) - not required for this project_
-   Use auditing tools (internally)
    -   Secureum articles
        -   [Audit Techniques & Tools 101](https://secureum.substack.com/p/audit-techniques-and-tools-101)
        -   [Audit Findings 101](https://secureum.substack.com/p/audit-findings-101)
        -   [Audit Findings 201](https://secureum.substack.com/p/audit-findings-201)
    -   Formal verification testing: solidity smt & else
    -   Fuzz testing (echidna): (semi-)random inputs
    -   Static analysers (mythril, slither)
    -   Differential Testing
    -   MythX (report)
    -   Etc.. (rattle, etheno, surya…)
        -   invariant testing
        -   symbolic execution
        -   mutation testing
