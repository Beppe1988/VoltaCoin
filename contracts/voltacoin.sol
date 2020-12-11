// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "./token/ERC20/ERC20.sol";
import "./utils/Staking.sol";
import "./access/Ownable.sol";

contract eoloVoltaCoin is ERC20, Ownable{

    constructor() ERC20("eoloVoltaCoin", "eVLT"){
        _mint(msg.sender, 100000000000000000000);
    }

    function transferFromOwner(address recipient, uint256 amount) public{
       transferFrom(owner(), recipient, amount);
    }

}

contract VoltaCoin is ERC20, Ownable {
    
    uint104 private percent;

    constructor() ERC20("VoltaCoin", "VOLTA") {
        percent = 80;
        _mint(msg.sender, 100000000000000000000);
    }


    Stake.Stakeholders[] stakes;

    function transferFrom(address _sender, address _recipient, uint256 _amount) virtual override public returns(bool){
        if(_recipient == owner()){
            if(_amount > 100){
                Stake.addStake(_sender, _amount, stakes);
            }
            if(_amount <= 100){
                Stake.removeStake(_sender, stakes, 0);
            }
        }
    }

    function percentRewardChange(uint104 _percent) private{
        percent = _percent;
    }

    function sendReward() private{
        eoloVoltaCoin e;
        for (uint256 s = 0; s < stakes.length; s++){
            
            uint256 reward = Stake.calculateReward(stakes[s]._stake, percent);
            e.transferFromOwner(stakes[s]._address, reward);
            
        }
    }



}