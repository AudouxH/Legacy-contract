//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Legacy {
    // create kid structure with amount want to send it, the time to maturity of kid and an bool to see if already paid
    struct Kid {
        uint amount;
        uint maturity;
        bool paid;
    }
    // map of all kids
    mapping(address => Kid) public Kids;
    // create admin who know who's giving money to they kids
    address public admin;

    constructor() {
        // set admin by sender
        admin = msg.sender;
    }

    // function that add kid into Kids map with timeMaturity and amount setting
    function addKid(address kid, uint timeMaturity, uint amount) external payable {
        // check if sender is admin
        require(msg.sender == admin, 'only admin access');
        // check if kid have already an account
        require(Kids[msg.sender].amount == 0, 'kids already exist');
        // set new kid into kids with construct variable
        Kids[kid] = Kid(amount, block.timestamp + timeMaturity, false);
    }

    // function for kids to withdraw their money
    function withdraw() external {
        // get kid account from kids
        Kid storage kid = Kids[msg.sender];
        // check if kid is arrived ar maturity
        require(kid.maturity <= block.timestamp, 'too early');
        // check if kid have a amount in his account
        require(kid.amount > 0, 'only kids can withdraw');
        // check if kid as already paid
        require(kid.paid == false, 'already paid');
        // transfer money to kid account
        payable(msg.sender).transfer(kid.amount);
        // set kid as paid
        kid.paid = true;
    }
}
