pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

/* 
* @title Has White List
* @dev make tokens taxable(you have to handle those variables as you wish in your token)
*/
contract Taxable is Ownable{
    //events
    event LogPercentageChanges(address sender,uint8 oldPercentage,uint8 newPercentage);
    event LogMinimunFeeChanges(address sender,uint256 oldMinimunFee,uint256 newMinimunFee);
    event StoppingChangingPercentage();
    event StoppingChangingMinimunFee();
    //state variables
    uint8 public percentage;
    uint256 public minimunFee;
    bool public cansetPercentage;
    bool public canChangeMinimunFee;
    //constructor
    function Taxable() public {
        cansetPercentage = true;
        canChangeMinimunFee = true;
    }
    /**
    * @dev change the contract percentage fee.
    * @param _percentage The new percentage.
    */
    function setPercentage(uint8 _percentage) onlyOwner public returns(bool){
        require(_percentage < 100);
        require(cansetPercentage);
        LogPercentageChanges(msg.sender,percentage,_percentage);
        percentage = _percentage;
        return true;
    }
    /**
    * @dev change the minimun fee.
    * @param _minimunFee The new minimun fee.
    */
    function setMinimunFee(uint256 _minimunFee) onlyOwner public returns(bool){
        require(canChangeMinimunFee);
        LogMinimunFeeChanges(msg.sender,minimunFee,_minimunFee);
        minimunFee = _minimunFee;
        return true;
    }
    /**
    * @dev make impossible to change percentage again
    */
    function stopSetPercentage() public onlyOwner returns(bool){
        require(cansetPercentage);
        cansetPercentage = false;
        StoppingChangingPercentage();
        return true;
    }  
    /**
    * @dev make impossible to change minimunFee again
    */
    function stopSetMinimunFee() public onlyOwner returns(bool){
        require(canChangeMinimunFee);
        canChangeMinimunFee = false;
        StoppingChangingMinimunFee();
        return true;
    }   
}