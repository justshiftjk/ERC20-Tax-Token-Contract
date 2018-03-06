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
contract ERC888Token is PausableToken,CappedToken,BurnableToken,Taxable,HasWhiteList{
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