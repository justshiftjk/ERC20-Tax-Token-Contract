pragma solidity ^0.4.18;

import "../ERC888Token.sol";

contract ERC888Mock is ERC888Token{

    function ERC888Mock(uint256 supply) public{
        require(supply > 0);
        totalSupply_ = supply;
        cap = supply;
        balances[msg.sender] = supply;
    }

}