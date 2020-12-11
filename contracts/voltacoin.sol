// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "./token/ERC20/ERC20.sol";
import "./utils/Staking.sol";
import "./access/Ownable.sol";

contract subVoltaCoin is ERC20, Ownable{
    
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol){
        _mint(msg.sender, 100000000000000000000);
    }

    function transferFromOwner(address recipient, uint256 amount) public onlyOwner{
       transferFrom(owner(), recipient, amount);
    }

}

contract VoltaCoin is ERC20, Ownable {
    
    uint104 private percent;
    address eVLT_address;
    address iVLT_address;
    address sVLT_address;

    constructor() ERC20("VoltaCoin", "VOLTA") {
        percent = 80;
        _mint(msg.sender, 100000000000000000000);
        subVoltaCoin eVLT = new subVoltaCoin("EoloCoin", "eVLT");
        subVoltaCoin iVLT = new subVoltaCoin("IdroCoin", "iVLT");
        subVoltaCoin sVLT = new subVoltaCoin("SunlightCoin", "sVLT");

        eVLT_address = address(eVLT);
        iVLT_address = address(iVLT);
        sVLT_address = address(sVLT);

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

    function sendReward() private returns(bool status){

        for (uint256 s = 0; s < stakes.length; s = s++){
            address _address = stakes[s]._address;
            uint256 reward = Stake.calculateReward(stakes[s]._stake, percent);
            if(block.timestamp >= (stakes[s]._rewardDate + 30 days)){
     
                (bool st1, ) = eVLT_address.call(abi.encodeWithSignature("transferFromOwner(address, uint256)",_address, reward));
                (bool st2, ) = iVLT_address.call(abi.encodeWithSignature("transferFromOwner(address, uint256)",_address, reward));
                (bool st3, ) = sVLT_address.call(abi.encodeWithSignature("transferFromOwner(address, uint256)",_address, reward));

                stakes[s]._rewardDate = block.timestamp;

                if(!st1 || !st2 || !st3){
                    status = false;
                }
            }
        }

        return status;
    }



}