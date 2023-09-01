// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Lottery{

    address public manager;
    address payable[] public participants;

    constructor(){
        manager=msg.sender;
    }
    
    receive() external payable
    {   require(msg.value==2 ether,"Please give sufficient balance");
        require(msg.sender!=manager);
        participants.push(payable (msg.sender));
        
    }
    
    function getbalance() public  view returns(uint)
    {    
        require(msg.sender==manager, "You are not the owner");
        return  address(this).balance;
    }

    //select randomly

    function random() public view returns (uint){
      return uint(  keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }
   
   function selectwinner() public view returns (address){
       require(msg.sender==manager,"you are not the manager");
       require(participants.length>=3);
       uint r=random();
       address payable winner;
       uint index=r% participants.length;
       winner=participants[index];
       return winner;

   }

  function transfermoney() public {
    require(msg.sender==manager);
    address payable  win= payable  (selectwinner());
    win.transfer(getbalance()/20);

  }

  function reset() public {

      participants=new address payable[](0);
  }

  


  

   
    
}