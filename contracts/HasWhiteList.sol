pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
/* 
* @title HasWhiteList
* @dev allow the contracts that inherit from this to have a whitelist
*/
contract HasWhiteList is Ownable{
    //events
    event LogAddressAdded(address sender,address added);
    event LogAddressDeleted(address sender,address removed);    
    event AddressMinimunFeeChanged(address sender,uint256 oldFee,uint256 newFee);
    event AddressPercentageChanged(address sender,uint256 oldPercentage,uint256 newPercentage);
    //mappings
    mapping (address => bool) isInWhitelist;
    mapping (address => uint8) whitelistPercentage;
    mapping (address => uint256) whitelistMinimunFee;

    function isInTheWhiteList(address acc) public constant returns(bool){
        return isInWhitelist[acc];
    }

    function getMinimunFee(address acc) public constant returns(uint256){
        return whitelistMinimunFee[acc];
    }

    function getPercentage(address acc) public constant returns(uint256){
        return whitelistPercentage[acc];
    }

    function addAccountInWhitelist(address acc,uint8 _percentage,uint256 _minimunFee) onlyOwner public returns(bool){
        require(!isInWhitelist[acc]);
        require(acc != 0);
        isInWhitelist[acc] = true;
        whitelistPercentage[acc] = _percentage;
        whitelistMinimunFee[acc] = _minimunFee;
        LogAddressAdded(msg.sender,acc);
        return true;
    }

    function deleteAccountFromWhitelist(address acc) onlyOwner public returns(bool){
        require(isInWhitelist[acc]);
        isInWhitelist[acc] = false;
        whitelistPercentage[acc] = 0;
        whitelistMinimunFee[acc] = 0;
        LogAddressDeleted(msg.sender,acc);
        return true;
    }

    function changeAccountMinimunFee(address acc,uint256 amount) onlyOwner public returns(bool){
        require(isInWhitelist[acc]);
        require(whitelistMinimunFee[acc] != amount);
        AddressMinimunFeeChanged(msg.sender,whitelistMinimunFee[acc],amount);
        whitelistMinimunFee[acc] = amount;
        return true;
    }

    function changeAccountPercentage(address acc,uint8 amount) onlyOwner public returns(bool){
        require(isInWhitelist[acc]);
        require(amount < 100);
        require(whitelistPercentage[acc] != amount);
        AddressPercentageChanged(msg.sender,whitelistPercentage[acc],amount);
        whitelistPercentage[acc] = amount;
        return true;
    }
}