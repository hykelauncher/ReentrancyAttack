// SPDX-License-Identifier: MIT
<<<<<<< HEAD
pragma solidity ^0.8.12;
=======
pragma solidity ^0.8.10;
>>>>>>> 16c9c029a458b73eb26dd82cedd92d75b228e926

contract ReentrancyGuard {
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }
}
<<<<<<< HEAD

contract ReentrancyGuard2 {
    uint256 private _guardCounter;

    constructor() {
        // The counter starts at one to prevent changing it from zero to a non-zero value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter);
    }
}

// contract MyContract is ReentrancyGuard {
//   function test() external nonReentrant {
//     ...
//   }
// }
=======
>>>>>>> 16c9c029a458b73eb26dd82cedd92d75b228e926
