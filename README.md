## Implementation.

## Current implementation

This repo's contracts are separated in 3 parts:

- [Taxable](https://github.com/Giulio2002/Ethereum-Taxable-Token/blob/master/contracts/Taxable.sol): have state variables used to make the contract taxable.
- [Whitelist](https://github.com/Giulio2002/Ethereum-Taxable-Token/blob/master/contracts/HasWhiteList.sol): Allow the owner to add custom fees rules for certain accounts.
- [The token itself](https://github.com/Giulio2002/Ethereum-Taxable-Token/blob/master/contracts/TaxableToken.sol): ERC20 with a fee in percentage on sending.

## Minimal viable implementation of the token, ready for use.

https://github.com/Giulio2002/Ethereum-Taxable-Token

## Taxable Token.

Ethereum-Taxable-Token is based on [ERC20](https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token/ERC20) token standard. It should be used to create token that you can tax as you wish.

```js
pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";
import "./CappedToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";
import "./Taxable.sol";
import "./HasWhiteList.sol";

/**
 * @title ERC888 Token
 * @dev ERC20 Token with fee on sending
 */
contract TaxableToken is PausableToken,CappedToken,BurnableToken,Taxable,HasWhiteList{
   //state variables
   string public name;
   string public symbol;
   uint8 public decimals;
  /**
  * @dev transfer token for a specified address burning a fee.
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);
    //required variables
    uint requiredPercentage;
    uint requiredMinimunFee;
    if(isInWhitelist[msg.sender]){
        requiredPercentage = whitelistPercentage[msg.sender];
        requiredMinimunFee = whitelistMinimunFee[msg.sender];
    }else{
        requiredPercentage = percentage;
        requiredMinimunFee = minimunFee;
    }
    require(_value > requiredMinimunFee);
    //expected fee
    uint fee = (_value * requiredPercentage)/100;
    //substraction
    balances[msg.sender] = balances[msg.sender].sub(_value);
    //check if the fee can be accepted
    if(fee < requiredMinimunFee){
        totalSupply_ -= requiredMinimunFee;
        _value -= requiredMinimunFee;
    }
    else{
        totalSupply_ -= fee;
        _value -= fee;
    }
    //transfer
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }
   /**
   * @dev Transfer tokens from one address to another burning a fee.
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
    //required variables
    uint requiredPercentage;
    uint requiredMinimunFee;
    if(isInWhitelist[msg.sender]){
        requiredPercentage = whitelistPercentage[msg.sender];
        requiredMinimunFee = whitelistMinimunFee[msg.sender];
    }else{
        requiredPercentage = percentage;
        requiredMinimunFee = minimunFee;
    }
    require(_value > requiredMinimunFee);
    //expected fee
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    uint fee = (_value * requiredPercentage)/100;
    //substraction
    balances[_from] = balances[_from].sub(_value);
    //check if the fee can be accepted
    if(fee < requiredMinimunFee){
        totalSupply_ -= requiredMinimunFee;
        _value -= requiredMinimunFee;
    }
    else{
        totalSupply_ -= fee;
        _value -= fee;
    }
    //transfer
    balances[_to] = balances[_to].add(_value);
    Transfer(_from, _to, _value);
    return true;
  }
}
```

## Taxable Token disadvantages.
  1. cost a lot of gas for deploying(4000000 gas on kovan)
  2. cost more gas in the sending operation(around 58000) than a normal ERC20(around 50000).

## Example of a possible contract created using this 'standard'

```js
pragma solidity ^0.4.18;

import "./TaxableToken.sol";

contract TaxableTokenMock is TaxableToken{
    function TaxableTokenMock(uint256 supply, uint256 _minimunFee, uint8 _percentage,string _name,string _symbol,uint8 _decimals) public{
        require(_percentage < 100);
        require(supply > 0);
        require(_decimals < 18);
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        minimunFee = _minimunFee;
        percentage = _percentage;
        totalSupply_ = supply;
        cap = supply;
        balances[msg.sender] = supply;
    }
}
```
## Info
* you can find a deployed instance of this token at https://kovan.etherscan.io/token/0x298c116572a58cd10980f090a17755b5d098e1a9
## How to use it
 * download this repo
 * import this repo's contracts in your contracts folder.
 * try with the example token
 
## Purpose
The ico's popularity have caused the creation of new economics standards for the sustainability and the increasing of the price of the emitted tokens 

Generally the price of a token is based on one of those two concepts:

   * Network Effect
   * Deflation using the burning

The idea is simple,we apply a tax to the sender when an amount of tokens are sent, usually in percentage.

### Example:

The Taxable token apply a tax to each transaction, so if A transfers N tokens to B, B receive N – t(N) tokens, where t(N) is a tax calculated usually in percentage.

#### The purpose can be:
 * gaining using the tax
 * deflationing the token using the burning so that the token become more expensive

## Methods

   * Set Percentage: define the percentage tax
   * Set Minimum Fee: define the minimun fee that an user can pay
   * AddWhitelistedAccount: make some selected accounts pay a different tax
   * ChangeWhitelistedPercentage: redefine the percentage for a whitelisted account
   * ChangeWhitelistedMinimumFee: redefine the minimun fee that a whitelisted account have to pay
   * DeleteWhitelistedAccount: delete an account from the whitelist
## how it works
   * A send 10 token to B
   * C has set the percentage to 10%
   * B receive 9 token,the one that miss is burned
   * C(the owner) can mint while the maximum supply is not reached
   * the owner can't mint more than the maximum supply
### Why C haven't received the token when A have sent his 10 tokes to B
I've realized that sending the token to C would have cost a big amount of gas to A,so: 

I replaced this operation with a burning(that cost a lot less),then i decided to make the owner mint the amount of token that had been burned.

acting that way results less expensive for the sender.

##### Remember: the owner can't mint more than the maximum supply
