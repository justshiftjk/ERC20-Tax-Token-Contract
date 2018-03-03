pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract HasWhiteList is Ownable{

    event LogAddressAdded(address sender,address added);
    event LogAddressDeleted(address sender,address removed);    
    event AddressFeeChanged(address sender,uint256 oldFee,uint256 newFee);

    mapping (address => bool) isInWhitelist;
    mapping (address => uint256) whitelistFee;

    function isInTheWhiteList(address acc) public constant returns(bool){
        return isInWhitelist[acc];
    }

    function getWhiteListFee(address acc) public constant returns(uint256){
        return whitelistFee[acc];
    }

    function addAccountFromWhitelist(address acc,uint256 amount) onlyOwner public returns(bool){
        require(!isInWhitelist[acc]);
        isInWhitelist[acc] = true;
        whitelistFee[acc] = amount;
        LogAddressAdded(msg.sender,acc);
        return true;
    }

    function deleteAccountFromWhitelist(address acc) onlyOwner public returns(bool){
        require(isInWhitelist[acc]);
        isInWhitelist[acc] = false;
        LogAddressDeleted(msg.sender,acc);
        return true;
    }

    function ChangeAccountFee(address acc,uint256 amount) onlyOwner public returns(bool){
        require(isInWhitelist[acc]);
        require(whitelistFee[acc] != amount);
        AddressFeeChanged(msg.sender,whitelistFee[acc],amount);
        whitelistFee[acc] = amount;
        return true;
    }
}