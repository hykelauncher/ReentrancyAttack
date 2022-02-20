from brownie import network, config, accounts, web3


def get_account():
    _acct = None
    _net = network.show_active()
    if _net == "development":
        _acct = accounts[0]
    else:
        _acct = accounts.add(config["wallets"]["from_key"])
    print(f"On the network {_net}, using account: {_acct}")
    return _acct


def decode_tx_data(tx, contract):
    _tx = web3.eth.get_transaction(tx)
    _contract = web3.eth.contract(
        address=contract[-1].address, abi=contract[-1].abi)
    _func_obj, _func_params = _contract.decode_function_input(_tx["input"])
    print(f"Function object : {_func_obj}")
    print(f"Function params : {_func_params}")


def print_tx(_tx):
    print(f"Contract Address : {_tx.contract_address}")
    print(f"Contract Name : {_tx.contract_name}")
    print(f"Info : {_tx.info()}")
    print(f"Error : {_tx.error()}")
