// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import "./token/ERC20/ERC20.sol";
import "./utils/Staking.sol";
import "./access/Ownable.sol";


// interface Aion
contract Aion {
    uint256 public serviceFee;
   
   function ScheduleCall(uint256 blocknumber, address to, uint256 value, uint256 gaslimit, uint256 gasprice, bytes memory data, bool schedType) public payable returns (uint,address){

   }

} 

/**
 * This contract is ownable and create a custom subcoin.
 */
contract subVoltaCoin is ERC20, Ownable{
    
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol){
        _mint(msg.sender, 100000000000000000000000);
        
    }

    function transferFromOwner(address recipient, uint256 amount) public onlyOwner{
       //transferFrom(owner(), recipient, amount);
       _mint(recipient, amount);
    }

}

/** 
 * This create a main token contract.
 */
contract VoltaCoin is ERC20, Ownable {
    
    uint104 private percent;
    address eVLT_address;
    address iVLT_address;
    address sVLT_address;
    address tVLT_address;

    /** 
     * Constructor contain: 
     *
     * percent: reward percentage;
     *
     * Subcoins contract creation;
     *
     * Subcoins contract addresses;
     */
    constructor() ERC20("VoltaCoin", "VOLTA") {
        percent = 80;
        _mint(msg.sender, 100000000000000000000000);
        subVoltaCoin eVLT = new subVoltaCoin("EoloCoin", "eVLT");
        subVoltaCoin iVLT = new subVoltaCoin("IdroCoin", "iVLT");
        subVoltaCoin sVLT = new subVoltaCoin("SunlightCoin", "sVLT");
        subVoltaCoin tVLT = new subVoltaCoin("ThermoCoin", "tVLT");

        eVLT_address = address(eVLT);
        iVLT_address = address(iVLT);
        sVLT_address = address(sVLT);
        tVLT_address = address(tVLT);

    }

    // Stakeholder variable in library
    Stake.Stakeholders[] stakes;

    /**
     * This override ERC20 function, adding the staking mechanism that
     * add or remove staking by sending or receiving main token amount
     * to the owner. 
     */
    function transferFrom(address _sender, address _recipient, uint256 _amount) virtual override public returns(bool){
        if(_recipient == owner()){
            if(_amount > 100){
                Stake.addStake(_sender, _amount, stakes);
            }
            if(_amount <= 100){
                (bool _isStakeholder, uint256 _s) = Stake.isStakeholder(_sender, stakes);
                if(_isStakeholder){
                    _transfer(owner(),_sender, _s);
                    Stake.removeStake(_sender, stakes, 0);
                    }
                }
            }
        }
    
    
    // This edit reward percentage
    function percentRewardSetup(uint104 _percent) private{
        percent = _percent;
    }

    function transferSubOwnership(address _address) public onlyOwner returns (bool status){
        (bool st1, ) = eVLT_address.call(abi.encodeWithSignature("transferOwnership(address)",_address));
        (bool st2, ) = iVLT_address.call(abi.encodeWithSignature("transferOwnership(address)",_address));
        (bool st3, ) = sVLT_address.call(abi.encodeWithSignature("transferOwnership(address)",_address));
        (bool st4, ) = tVLT_address.call(abi.encodeWithSignature("transferOwnership(address)",_address));


        if(!st1 || !st2 || !st3 || !st4){
            status = false;
        }

        return status;
    }
    
    /**
     * This function is for aion scheduling. 
  
            Contract Addresses
            MainNet 	0xCBe7AB529A147149b1CF982C3a169f728bC0C3CA
            Ropsten 	0xFcFB45679539667f7ed55FA59A15c8Cad73d9a4E
            Rinkeby 	0xeFc1d6479e529D9e7C359fbD16B31D405778CE6e
            Kovan 	    0x2fC197cD7897f41957F72e8E390d5a7cF2858CBF
    */
    function schedule_rqsr() public payable {

        Aion aion = Aion(0xFcFB45679539667f7ed55FA59A15c8Cad73d9a4E);
        bytes memory data = abi.encodeWithSelector(bytes4(keccak256('sendReward()')));
        uint callCost = 200000*1e9 + aion.serviceFee();
        aion.ScheduleCall{value:callCost}( block.timestamp + 1 days, address(this), 0, 200000, 1e9, data, true);
    }
    
    /**
     * This function send rewards to stakeholders and return a status. 
     */
    function sendReward() public onlyOwner returns(bool status){

        for (uint256 s = 0; s < stakes.length; s = s++){
            address _address = stakes[s]._address;
            uint256 reward = Stake.calculateReward(stakes[s]._stake, percent);
            if(block.timestamp >= (stakes[s]._rewardDate + 30 days)){
     
                (bool st1, ) = eVLT_address.call(abi.encodeWithSignature("transferFromOwner(address, uint256)",_address, reward));
                (bool st2, ) = iVLT_address.call(abi.encodeWithSignature("transferFromOwner(address, uint256)",_address, reward));
                (bool st3, ) = sVLT_address.call(abi.encodeWithSignature("transferFromOwner(address, uint256)",_address, reward));
                (bool st4, ) = tVLT_address.call(abi.encodeWithSignature("transferFromOwner(address, uint256)",_address, reward));

                stakes[s]._rewardDate = block.timestamp;

                if(!st1 || !st2 || !st3 || !st4){
                    status = false;
                }
            }
        }

        return status;
    }



}