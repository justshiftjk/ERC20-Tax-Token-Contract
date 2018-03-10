pragma solidity ^0.4.18;

import "../TaxableToken.sol";

contract TaxableTokenMock is TaxableToken{
    function TaxableTokenMock(uint256 supply, uint256 _minimunFee, uint8 _percentage,string _name,string _symbol,uint8 _decimals) public{
        //we don't need test for this
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