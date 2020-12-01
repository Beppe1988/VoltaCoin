// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

library Stake {

    struct Stakeholders{
        address _address;
        uint256 _stake;
    }

    function isStakeholder(address addr, Stakeholders[] storage addrList) public view returns(bool, uint256){
        for(uint256 s = 0; s < addrList.length; s+=1){
            if(addr == addrList[s]._address){
                return (true, s);
            }
        }
        return (false, 0);
    }

    function addStake(address addr, uint256 qty, Stakeholders[] storage addrList) public{

        (bool _isStakeholder, uint256 s) = isStakeholder(addr,addrList);

        if(_isStakeholder){ 

            if(addr == addrList[s]._address && addrList[s]._stake != qty){
                addrList[s]._stake = qty;
                
            }

        }

        if(!_isStakeholder){
            addrList.push()._address = addr;
            addrList.push()._stake = qty;
        }


    }

    function removeStake(address addr, Stakeholders[] storage addrList) public{

        (bool _isStakeholder, uint256 s) = isStakeholder(addr,addrList);
        
        if(!_isStakeholder){
            return revert("This address don't have staked tokens!");
        }
        
        if(addr == addrList[s]._address){

            delete addrList[s]._address;
            delete addrList[s]._stake;
            
        }
    }
}