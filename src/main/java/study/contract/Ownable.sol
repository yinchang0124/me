pragma solidity ^0.4.24;

//Ownable 合同具有所有者地址，并提供基本授权控制功能，这简化了“用户权限”的实现
contract Ownable{
    address public owner;

    //该构造函数将合约“所有者”设置为部署合约的地址。
    function Ownable(){
        owner = msg.sender;
    }

    //不允许所有者以外的任何帐户调用。
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    //允许当前所有者将合同的控制权转移给newOwner。
    function transferOwnership(address newOwner)onlyOwner{
        if(newOwner != address(0)){
            owner =newOwner;
        }
    }
}
