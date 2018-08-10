pragma solidity ^0.4.23;

contract Splitter {
    address public owner;
    address public splitRecipientOne;
    address public splitRecipientTwo;
    
    constructor (address one, address two) public {
        owner = msg.sender;
        splitRecipientOne = one;
        splitRecipientTwo = two;
    }
    
    modifier isAlice () {
        assert(msg.sender == owner);
        _;
    }
    
    function splitAmount (uint amount) private pure returns (uint amountForSplit) {
        if (amount % 2 != 0) {amountForSplit = amount/2 ;}
        else {amountForSplit = (amount-1)/2 ;}
        return amountForSplit;
    }
    
    function split () public isAlice payable {
        uint valueToSend;
        
        assert (msg.value > 0);
        valueToSend = splitAmount(msg.value);
        splitRecipientOne.transfer(valueToSend);
        splitRecipientTwo.transfer(valueToSend);
    }    
}

