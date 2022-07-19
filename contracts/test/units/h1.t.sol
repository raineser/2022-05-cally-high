pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import "../shared/Fixture.t.sol";

import "src/Cally.sol";


contract h1 is Test, Fixture {

    function testItSetsFee() public {
        // arrange
        uint256 newFeeRate = 1000;

        // act
        c.setFee(newFeeRate);
        uint256 feeRate = c.feeRate();

        // assert
        assertEq(feeRate, newFeeRate, "Should have set fee rate");
    }

}