// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

interface HalbornInterface {

    function deposit(uint _amount, address _sender) 
        external payable;

    function withdraw(address _user)
        external payable;

    function getContractBalance()
        external view
        returns (uint256);
 
}
