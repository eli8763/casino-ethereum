// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract Casino {
    address public owner;
    mapping(address => uint256) public playerBalances;

    event Deposit(address indexed player, uint256 amount);
    event BetPlaced(address indexed player, uint256 betAmount, uint256 result);
    event Withdraw(address indexed player, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // 玩家存入ETH到合约作为游戏筹码
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        playerBalances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function placeBet(uint256 betNumber) external payable {
        require(betNumber > 0 && betNumber <= 10, "Bet number must between 1 and 10");
        require(playerBalances[msg.sender] >= betNumber * 1 ether, "Insufficient balance");

        uint256 randomResult = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 10 + 1;
        
        if(randomResult == betNumber) {
            playerBalances[msg.sender] += betNumber * 1 ether;
        } else {
            playerBalances[msg.sender] -= betNumber * 1 ether;
        }

        emit BetPlaced(msg.sender, betNumber * 1 ether, randomResult);
    }

    function withdraw(uint256 withdrawAmount) external {
        require(playerBalances[msg.sender] >= withdrawAmount, "Insufficient withdraw balance");
        payable(msg.sender).transfer(withdrawAmount);
        playerBalances[msg.sender] -= withdrawAmount;
        emit Withdraw(msg.sender, withdrawAmount);
    }

    function fundContract() external payable onlyOwner {}
    
    function getContractBalance() external view returns(uint256) {
        return address(this).balance;
    }
}
