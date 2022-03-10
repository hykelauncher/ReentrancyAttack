# Reentrancy Attack with brownie and hardhat

This project demonstrates the reentrancy attack using brownie and hardhat network
The contract used is ReentrancyAttack from [Solidy by Example site], (https://solidity-by-example.org/hacks/re-entrancy/)
The ReentrancyAttack.sol contract is commented with console.log, showing different values during the execution of different functions in the contracts.

Clone the repository

```
git clone https://.....
```

Install hardhat dependencies (npm install) and start the hardhat network:

```
npm install
npx hardhat node
```

Before executing deployments, make sure to export to .env the private key of the first account from the hardhat network

example in .env:

```
export PRIVATE_KEY=0xaaaaaaaaaaaaaaaaaaa
```

Then run

```
source .env
brownie run scripts/deploy.py
```

Watch the hardhat network console during the execution of calls in the brownie deploy.py
It shows different values for contracts and accounts during calls.

![hardhat_console_log](https://user-images.githubusercontent.com/88323108/154864715-c6a69c19-ddd8-42b1-8bab-1a9074e137a5.png)

![brownie_script_log](https://user-images.githubusercontent.com/88323108/154864745-0d9e14c0-0795-4868-8cfe-209d6694d178.png)

The contract ReentrancyGuard shows the declaration of the noReentrant modifier, a utiliser in the function withdra() in order to ptotect it from reentrancy attacks.
