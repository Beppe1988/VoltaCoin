// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

library Stake {

    struct Stakeholders{
        address _address;
        uint256 _stake;
    }

    function isStakeholder(address addr, Stakeholders[] storage addrList) public view returns(bool){
        for(uint256 s = 0; s < addrList.length; s+=1){
            if(addr == addrList[s]._address){
                return true;
            }
        }
        return false;
    }


}