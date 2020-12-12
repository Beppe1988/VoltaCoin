// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @dev A stake library that allows ERC20 tokens holders to stake their tokens
 * simply send them to tokens owner or via Javascript.  
 *
 * The reward 
 */
library Stake {

    /**
     * @dev a new struct type that memorize the address of the staker, 
     * amount of the stake and the date when it was created or when it
     * receive last reward. 
     */
    struct Stakeholders{
        address _address;
        uint256 _stake;
        uint _rewardDate;
    }

    /**
     * @dev this function check if an address is stakeholder.
     *
     * It return boolean status and the position of the address in array.
     */
    function isStakeholder(address addr, Stakeholders[] storage addrList) internal view returns(bool, uint256){
        for(uint256 s = 0; s < addrList.length; s+=1){
            if(addr == addrList[s]._address){
                return (true, s);
            }
        }
        return (false, 0);
    }

    /**
     * @dev this function add a stakeholder or update its amount.
     */
    function addStake(address addr, uint256 qty, Stakeholders[] storage addrList) internal{

        (bool _isStakeholder, uint256 s) = isStakeholder(addr,addrList);

        if(_isStakeholder){ 

            if(addr == addrList[s]._address && addrList[s]._stake != qty){
                addrList[s]._stake = qty;
                
            }

        }

        if(!_isStakeholder){
            addrList.push()._address = addr;
            addrList.push()._stake = qty;
            addrList.push()._rewardDate = block.timestamp;
        }


    }
    /**
     * This function remove a stakeholder.
     *
     * The _change variable is a setup for web apps in java that can allow 
     *
     * the user to remove arbitrary amount of stake.
     */
    function removeStake(address addr, Stakeholders[] storage addrList, uint256 _change) internal{

        (bool _isStakeholder, uint256 s) = isStakeholder(addr,addrList);
        
        if(!_isStakeholder){
            return revert("This address don't have staked tokens!");
        }
        
        if(addr == addrList[s]._address && _change == 0){

            delete addrList[s]._address;
            delete addrList[s]._stake;
            
        }

        if(addr == addrList[s]._address && _change != 0){

            addrList[s]._stake -= _change;
            
        }
    }
    /**
    * This function calculate reward for the stakeholders by passing a custom percentage. 
    */
    function calculateReward(uint256 _stake, uint104 percent) internal pure returns(uint256 data){
        data = (_stake * percent) / 100;
        return data;
    }
}