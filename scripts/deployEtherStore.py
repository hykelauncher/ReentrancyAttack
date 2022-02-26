from brownie import accounts, config, chain, network, EtherStore, EtherStoreAttack
from scripts.helpful_scripts import get_account, print_tx
from web3 import Web3


def print_balances(msg):
    es_bal = Web3.fromWei(EtherStore[-1].balance(), "ether")
    att_bal = Web3.fromWei(EtherStoreAttack[-1].balance(), "ether")
    a0bal = Web3.fromWei(accounts[0].balance(), "ether")
    a1bal = Web3.fromWei(accounts[1].balance(), "ether")
    a2bal = Web3.fromWei(accounts[2].balance(), "ether")
    print(f"{msg} :EtherStore Balance is {es_bal} ether")
    print(f"{msg} :EtherStoreAttack Balance is {att_bal} ether")
    print(f"{msg} :a[0] balance is {a0bal} ether")
    print(f"{msg} :a[1] balance is {a1bal} ether")
    print(f"{msg} :a[2] balance is {a2bal} ether")


def main():
    # network.main.gas_limit(chain.block_gas_limit)
    # network.main.gas_buffer(None)
    # network.main.gas_price("2 gwei")
    account = get_account()

    e = EtherStore.deploy({"from": account})
    print(f"EtherStore Contract deployed at {e}")

    a = EtherStoreAttack.deploy(EtherStore[-1].address, {"from": account})
    print(f"EtherStoreAttack Contract deployed at {a}")

    # balances after deplopying contracts
    print_balances("Initial,after contracts deployment")

    # a[0] and a[1] is depositing 1 ether to EtherStore
    tx = EtherStore[-1].deposit({"from": accounts[0], "amount": "1 ether"})
    tx.wait(1)
    tx = EtherStore[-1].deposit({"from": accounts[1], "amount": "1 ether"})
    tx.wait(1)
    print_balances("After deposit")

    # Attacking EtherStore from account a[2]
    tx = EtherStoreAttack[-1].attack({"from": accounts[2],
                                     "amount": "1 ether"})
    tx.wait(1)
    print_balances("After attack")

    # recuperate the ethers from the Attack contract into a[2]
    print("Recuperating ethers into a[2]:")
    EtherStoreAttack[-1].send({"from": accounts[2]})
    tx.wait(1)
    print_balances("After recup")
