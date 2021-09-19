// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract StartupPortal {
    uint totalIdeas;
    uint private seed;

    // events in Solidity
    event NewIdea(address indexed from, uint timestamp, string message, bool winner);

    // Struct named idea.
    // A struct is a custom datatype where we can customize what
    // we want to hold inside it

    struct Idea {
        address entrepeneur; // the address of the user who waved
        string message; // the message the user snet
        uint timestamp; // the timestamp when the user waved
        bool winner;
    }

    // Variables ideas that lets me store an array of structs
    // This is what lets me hold all the ideas anyone ever sends to me
    Idea[] ideas;

    // This is and address => uint mapping, meaning I can associate
    // an address with a number. In this case, i'll be storing the 
    // address with th elast time the user sent and idea.
    mapping(address => uint) public lastSentAt;

    constructor() payable {
        console.log("We have constructed a smart contract!");
    }

    function idea(string memory _message) public {
        // We need to make sure the current timestamp is at least 15 minutes
        // bigger than the last timestamp we stored
        require(lastSentAt[msg.sender] + 10 minutes < block.timestamp, "Wait for 10 minutes");

        // update the current timestamp we have for the user
        lastSentAt[msg.sender] = block.timestamp;

        totalIdeas += 1;
        console.log("%s sent the idea %s", msg.sender, _message);

        // Generate a Pseudo random number in the range 100
        uint randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %s", randomNumber);

        // set the generated random number as the seed for the next one
        seed = randomNumber;

        // Give a 50% chance that the user wins the prize
        if(randomNumber < 50){
            console.log("%s won!", msg.sender);
            uint prizeAmount = 0.0001 ether;
            require(prizeAmount <= address(this).balance, "Trying to withdraw more money than the contract has.");
            (bool success,) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
            // Store idea data in array
            ideas.push(Idea(msg.sender, _message, block.timestamp, true));
            emit NewIdea(msg.sender, block.timestamp, _message, true);
        } else {
            // Store idea data in array
            ideas.push(Idea(msg.sender, _message, block.timestamp, false));
            emit NewIdea(msg.sender, block.timestamp, _message, false);
        }

        
    }

    // will return the struct array of ideas to us. 
    function getAllIdeas() view public returns (Idea[] memory){
        return ideas;
    }

    function getTotalIdeas() view public returns (uint){
        console.log("We have %d total startup ideas", totalIdeas);
        return totalIdeas;
    }
}
