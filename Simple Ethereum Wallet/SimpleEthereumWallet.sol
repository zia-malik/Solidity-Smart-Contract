// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract EthWallet{
    address public owner;

    error InvalidUser();
    error InsufficientBalance();

    modifier invalidUser() {
        if(msg.sender != owner)
            revert InvalidUser();
        _;
    }

    modifier insufficientBalance() {
        if(balanceOf[msg.sender] <= 1 wei)
            revert InsufficientBalance();
        _;
    }

    mapping(address => uint) balanceOf;

    constructor() payable{
        owner = payable(msg.sender);
    }

    function deposit() payable external invalidUser {
        balanceOf[msg.sender] = msg.value;
    }

    function withdrawn(uint _amount) payable external invalidUser insufficientBalance {
        balanceOf[msg.sender] -=  _amount;
        payable(msg.sender).transfer(_amount);
    }

    function transfer(address payable _other, uint _amount) external payable invalidUser insufficientBalance {
        balanceOf[msg.sender] -=  _amount;
        _other.transfer(_amount);
    }

    function getBalance() external view invalidUser returns(uint balance) {
        balance = address(this).balance;
    }

    function setNewOwner(address payable _newOwner) external invalidUser {
        owner = _newOwner;
    }

    function getOriginOwner() external view returns(address) {
        return tx.origin;
    }

    receive() payable external {}
}