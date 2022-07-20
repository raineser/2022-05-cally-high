/*

Inefficiency in the Dutch Auction due to lower duration

https://github.com/code-423n4/2022-05-cally-findings/issues/138

*/

pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import "../shared/Fixture.t.sol";

import "src/Cally.sol";


contract t2 is Test, Fixture {



    function testInefficiency() public {

        uint256 startingStrike = 55 ether;

        uint32 time = uint32(block.timestamp) + 24 hours;

        uint256 reserveStrike = 13.5 ether;

        uint256 strike;

        strike = c.getDutchAuctionStrike(startingStrike, time, reserveStrike);

        require(strike == startingStrike);

        time = uint32(block.timestamp) + 11 hours ;

        strike = 0;

        strike = c.getDutchAuctionStrike(startingStrike, time, reserveStrike);

        // strike has reduced to reserveStrike in only 13 hours instead
        // of 24 hours

        require(strike == reserveStrike);
    }





}