# Proof of Read (Experimental)

1. Create author's account (EOA)
1. Send a book information as a transaction to Ethereum network
1. Deploy Smart Contract
1. Record your reading history and review

## Send a book information as a transaction

```console
geth> eth.sendTransaction({from: eth.accounts[0],
                           to:eth.accounts[1],
                           value:web3.toWei(0.1, "ether"),
                           data: })
```

```json
{
    "version": 0.9,
    "isbn": 123,
    "authors": [
        {
            "address": "0x022a0e4340a4b422ca67fb07d1da99a8d0642bc0",
            "loyalty": 58.3
        },
        {
            "address": "0x0eb55d2572bc359a2806fba9d939cb888509adaa",
            "loyalty": 41.7
        }
    ]
}
```

## Deploy Smart Contract

## Record your reading history and review

