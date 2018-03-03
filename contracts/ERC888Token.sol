pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";
import "./CappedToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";
import "./Taxable.sol";
import "./HasWhiteList.sol";

contract ERC888Token is PausableToken,CappedToken,BurnableToken,Taxable,HasWhiteList{

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_value > minimunFee);
    require(_to != address(0));
    require(_value <= balances[msg.sender]);
    uint fee = (_value * percentage)/100;
    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    if(fee < minimunFee){
        totalSupply_ -= minimunFee;
        _value -= minimunFee;
    }
    else{
        totalSupply_ -= fee;
        _value -= fee; 
    }
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }
  
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_value > minimunFee);
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
    if(fee < minimunFee){
        totalSupply_ -= minimunFee;
        _value -= minimunFee;
    }
    else{
        totalSupply_ -= fee;
        _value -= fee; 
    }
    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

}