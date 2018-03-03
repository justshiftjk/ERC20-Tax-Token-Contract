pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract Taxable is Ownable{

    event LogPercentageChanges(address sender,uint8 oldPercentage,uint8 newPercentage);
    event LogMinimunFeeChanges(address sender,uint256 oldMinimunFee,uint256 newMinimunFee);
    event StoppingChangingPercentage();
    event StoppingChangingMinimunFee();

    uint8 public percentage;
    uint256 public minimunFee;
    bool public canChangePercentage;
    bool public canChangeMinimunFee;

    function Taxable() public {
        canChangePercentage = true;
        canChangeMinimunFee = true;
    }

    function changePercentage(uint8 _percentage) onlyOwner public returns(bool){
        require(canChangePercentage);
        LogPercentageChanges(msg.sender,percentage,_percentage);
        percentage = _percentage;
        return true;
    }

    function changeMinimunFee(uint256 _minimunFee) onlyOwner public returns(bool){
        require(canChangeMinimunFee);
        LogMinimunFeeChanges(msg.sender,minimunFee,_minimunFee);
        minimunFee = _minimunFee;
        return true;
    }

    function stopChangePercentage() public onlyOwner returns(bool){
        require(canChangePercentage);
        canChangePercentage = false;
        StoppingChangingPercentage();
        return true;
    }  

    function stopChangeMinimunFee() public onlyOwner returns(bool){
        require(canChangeMinimunFee);
        canChangeMinimunFee = false;
        StoppingChangingMinimunFee();
        return true;
    }   
}