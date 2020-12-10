// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "./token/ERC20/ERC20.sol";
import "./utils/Staking.sol";

contract VoltaCoin is ERC20 {
    

    address private owner;

    constructor() ERC20("VoltaCoin", "VOLT") {
        owner = msg.sender;
        _mint(owner, 100000000000000000000);
    }


    Stake.Stakeholders[] stakes;

    function transferFrom(address sender, address recipient, uint256 amount) virtual override public returns(bool){
        if(recipient == owner){
            if(amount > 100){
                Stake.addStake(sender, amount, stakes);
            }
            if(amount <= 100){
                Stake.removeStake(sender, stakes, 0);
            }
        }
    }

}