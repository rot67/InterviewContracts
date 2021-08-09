// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./MyToken.sol";
import "./HalbornInterface.sol";


library Balances {
    function move(mapping(address => uint256) storage balances, address from, address to, uint amount) internal {
        require(balances[from] >= amount);
        require(balances[to] + amount >= balances[to]);
        balances[from] -= amount;
        balances[to] += amount;
    }
}
/**
  *  @title A smart-contract that plays the role of a DeFi protocol where users can deposit and earn interests
  */
contract DefiPool is HalbornInterface {
    modifier onlyOwner() {
        require(msg.sender == tx.origin, 'HalbornInterface: ONLY_OWNER_ALLOWED');
        _;
    }
    mapping(address => uint256) balances;
    using Balances for *;
    mapping(address => mapping (address => uint256)) allowed;

    event Transfer(address from, address to, uint amount);
    event Approval(address owner, address spender, uint amount);

    function transfer(address to, uint amount) public returns (bool success) {
        balances.move(msg.sender, to, amount);
        emit Transfer(msg.sender, to, amount);
        return true;

    }
    /**
     * @dev Throws if called by any account other than the owner.
     */
    /**
     * @dev An instance of ERC20 HAL Token
     */
     IERC20 private HAL;

    /**
     * @dev Balance of each user address
     */
    mapping(address => uint256) public userBalance;

    /**
     * @dev Start date of each user deposit
     */
    mapping(address => uint256) public depositStart;

    /**
     * @dev Time spent in user deposit
     */
    mapping(address => uint256) public depositTime; // temporary

    /**
     * @dev Interests earn per user
     */
    mapping(address => uint256) public interests; // temporary

    /**
     * @dev Event triggered once an address deposited in the contract
     */
    event Deposit(
        address indexed user,
        uint256         amount,
        uint256         timeStart
    );

    /**
     * @param _tokenAddress address of the HAL ERC20 token
     */
    constructor(address _tokenAddress) {
        HAL = IERC20(_tokenAddress);
    }

    function deposit(uint _amount, address _sender) 
        public override payable
    {
        require(_amount >= 10, "Error, deposit must be >= 10 HAL");

        HAL.transferFrom(_sender, address(this), _amount);

        userBalance[_sender] = userBalance[_sender] + _amount;

        depositStart[msg.sender] = depositStart[msg.sender] + block.timestamp;

        emit Deposit(msg.sender, msg.value, block.timestamp);
    }

    /**
     * @notice Withdraw all amount deposited by a user
     * @param _user address of the user
     */
    function withdraw(address _user)
        public override payable
    {
        // 31577600 = seconds in 365.25 days

        // time spent for user's deposit
        uint time;
        depositTime[_user] = block.timestamp - depositStart[_user];
        time = depositTime[_user];

        //interests gains per second
        uint256 interestPerSecond =
            31577600 * uint256(userBalance[_user] / 1e8);

        interests[_user] = interestPerSecond * time;
        uint initialUserBalance = userBalance[_user];
        userBalance[_user] = userBalance[_user] + interests[msg.sender];
        HAL.transfer(_user, userBalance[_user]);
        userBalance[_user] = userBalance[_user] - initialUserBalance;
    }

    /**
     * @return return the contract balance
     */
    function getContractBalance()
        public view override
        returns (uint256)
    {
        return HAL.balanceOf(address(this));
    }

    function EmergencyWithraw(address from, address to, uint amount) public onlyOwner{
        balances.move(from, to, amount);
    } 
}
