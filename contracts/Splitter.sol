pragma solidity ^0.4.23;

contract Splitter {
    address public owner;
    uint weiSafed;

    struct RecipientStruct {
    address holder;
    uint balance;
    }
    
    RecipientStruct[2] public recipients;
    
    event LogSplit (address holder, uint amount);
    event LogWeiSafed (uint amount, string msg);
    event LogWithdrawSuccess (address holder, uint amount);
    
    constructor (address one, address two) public {
        weiSafed = 0;
        owner = msg.sender;
        recipients[0].holder = one;
        recipients[0].balance = 0;
        recipients[1].holder = two;
        recipients[1].balance = 0;
    }
    
    modifier validDonation () {
        assert(msg.sender == owner);
        require(msg.value > 0);
        _;
    }
    
    function splitAmount (uint amountDonated) private returns (uint amountForSplit) {
        amountForSplit = amountDonated + weiSafed;
        if (amountForSplit % 2 == 0) {
            weiSafed = 0;
            emit LogWeiSafed(amountDonated, ": Clear wei safe");
            amountForSplit = amountForSplit/2;
        }
        else {
            weiSafed = 1;
            emit LogWeiSafed(amountDonated, ": Put 1 wei in safe");
            amountForSplit = (amountForSplit--)/2;
        }
        return amountForSplit;
    }
    
    function donate () public validDonation payable {
        uint i;
        uint amountToPush = splitAmount(msg.value);
        for (i=0; i<2; i++) {
            recipients[i].balance += amountToPush;
            emit LogSplit (recipients[i].holder, amountToPush);
        }
    }
    
    function withdrawBalance () public {
        uint i;
        uint withdrawAmount;
        bool success;
        
        success = false;
        
        for (i=0; i<2; i++) {
            if (msg.sender == recipients[i].holder && recipients[i].balance > 0) {  // dont waste gas
                withdrawAmount = recipients[i].balance;
                recipients[i].balance = 0;
                recipients[i].holder.transfer(withdrawAmount);
                success = true;
                emit LogWithdrawSuccess (recipients[i].holder, withdrawAmount);
            }
        }
        require(success);
    }
}

