// .../faucet_barebone/app/faucet.js
/* if (typeof web3 !== 'undefined') {
    // Don't lose an existing provider, like Mist or Metamask
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}
*/ 

web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

web3.eth.getCoinbase(function(err, coinbase) {
    if (err) {
        console.error(err);
    } else {
        console.log("Coinbase: " + coinbase);
    }
});

// Your deployed address changes every time you deploy.
const splitterAddress = "0xa4ccf8892aa5ec333eda9c28854efa37f461a771"; // <-- Put your own
const splitterContractFactory = web3.eth.contract(JSON.parse(SplitterCompiled.contracts["./Splitter.sol:Splitter"].abi));
const splitterInstance = splitterContractFactory.at(splitterAddress);

// Query eth for contract's balance
web3.eth.getBalance(splitterAddress, function(err, balance) {
    if (err) {
        console.error(err);
    } else {
        console.log("Splitter balance: " + balance);
    }
});

// Query the contract directly
splitterInstance.getBalance.call(function(err, balance) {
    if (err) {
        console.error(err);
    } else {
        console.log("Splitter balance: " + balance);
    }
});

/**
function donate_orig(donAmount) {
    web3.eth.getCoinbase(function(err, coinbase) {
        if (err) {
            console.error(err);
        } else {
            web3.eth.sendTransaction( { 
                from: coinbase, 
                to: splitterAddress,
                value: donAmount,
		gas: 100000 
            }, function(err, txn) {
                if (err) {
                    console.error(err);
                } else {
                    console.log("donate txn: " + txn);
                }
            });
        }
    });
}
**/

function donate(donAmount) {
    web3.eth.getCoinbase(function(err, coinbase) {
        if (err) {
            console.error(err);
        } else {
		splitterInstance.donate.sendTransaction({ from: coinbase, value: donAmount, gas: 100000 }, 
		(err, result) => { console.log("donate txn: " + result); } );
        }
    });
}
