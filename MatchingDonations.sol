pragma solidity 0.8.1;
 
//A philanthropist has agreed to send matching contributions for all amounts received from the public
//Given: the address of the philanthropist
//philanthropist sends his maximum donation first, and only then money is accepted from the public
//contract can be ended after 30 days, where any remaining balance of the philanthropist is refunded to him
 
contract donation {
    
    //setting up global variables
    // DO NOT SEND ETH TO THESE ADDRESS - THE PRIVATE KEYS HAVE BEEN BURNED AND YOUR ETH WILL BE LOST FOREVER
    // if you deploy this code, make sure you change these addresses
    address payable addressOfPhilanthropist = payable(0x6ed0B157827d1F04EcE69e4BB19FBEB652f23A0d); 
    address payable addressOfCharity = payable(0x92893c3fEb851bc5D75f976bfA7713BEdD1E0Eb3);
    uint receiptFromPhilanthropist;
    uint receiptFromOthers; 
    uint startTime;
    
    //constructor to set the start time when the contract is created
    constructor() {
        startTime = block.timestamp;
    }
    
    
    //receive ether and maintain separate totals for receipts from the philanthropist and from everyone else
    receive() external payable {
        if (msg.sender == addressOfPhilanthropist) {
            receiptFromPhilanthropist += msg.value; 
        }
        else {
            require((receiptFromOthers + msg.value) > receiptFromOthers); //protecting against overflow
            receiptFromOthers += msg.value;
            require((receiptFromOthers * 2) > receiptFromOthers); //protecting against overflow
        }
    }
    
    function withdraw() public {
        
        //check if 30 days have passed
        require((block.timestamp - startTime) > 30 days, "30 days have not yet passed");
        
        //send matching donation and refund the balance to the philanthropist
        if (receiptFromOthers < receiptFromPhilanthropist) {
            addressOfCharity.transfer((receiptFromOthers * 2));
            addressOfPhilanthropist.transfer(address(this).balance);
        }
        else {
            addressOfCharity.transfer(address(this).balance);
        }
    }
}
