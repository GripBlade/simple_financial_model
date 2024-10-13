// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract DiscreteStakingModel {
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardsToken;

    address public owner; // 合约拥有zhe

    uint256 public rewardRate; // 奖励速率
    uint256 public totalReward; // 奖励总数
    uint256 public endTime; // 结束时间
    uint256 public rewardPerTokenStored; // 奖励总量/总质押量
    uint256 public updateTime; // 最后更新时间

    uint256 public totalStaked; // 总质押数量
    mapping(address => uint256) public userBalance; // 用户质押余额
    mapping(address => uint256) public userRewardPerTokenPaid; // 用户质押余额

    event Deposit(address indexed user, uint256 amount); // 质押事件
    event Withdraw(address indexed user, uint256 amount); // 取出事件
    event Reward(address indexed user, uint256 amount); // 奖励事件

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier updateReward(address _account) {
        rewardPerTokenStored = rewardPerToken();
        // 更新奖励速度
        updatedAt = lastTimeRewardApplicable();
        // 更新最后奖励时间

        if (_account != address(0)) {
            rewards[_account] = earned(_account);
            userRewardPerTokenPaid[_account] = rewardPerTokenStored;
        }
        _;
    }

    constructor(uint256 _rewardRate, address _stakingToken, address _rewardsToken, uint256 _endTime) public {
        owner = msg.sender;
        rewardRate = _rewardRate;
        stakingToken = _stakingToken;
        rewardsToken = _rewardsToken;
        endTime = _endTime;
    }

    // 质押函数
    function stake(uint256 _amount) public updateReward {
        require(block.timestamp < endTime, "staking has ended");
        require(_amount > 0, "amount should be greater than 0");
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        // 使用前需要approve
        userBalance[msg.sender] += _amount;
        totalStaked += _amount;
        emit Deposit(msg.sender, _amount);
    }

    // withdraw 取回用户的钱，并更新用户的余额
    function withdraw(uint _amount) external updateReward(msg.sender) {
        require(_amount > 0, "amount = 0");
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }


    function earned(address _account) public view returns (uint256) {
        uint256 balance = userBalance[_account];
        return balance * (rewardPerTokenStored - userRewardPerTokenPaid[_account]);
    }

    function getReward() public updateReward(msg.sender) {
        uint256 reward = earned(msg.sender);
        require(reward > 0, "no reward available");
        rewardsToken.transfer(msg.sender, reward);
        emit Reward(msg.sender, reward);
    }


    function rewardPerToken() public view returns (uint) {
        if (totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
        rewardPerTokenStored +
        ((rewardRate * (lastTimeRewardApplicable() - updatedAt)) * 1e18) /
        totalSupply;
    }


    function lastTimeRewardApplicable() public view returns (uint) {
        return _min(block.timestamp, finishAt);
    }

    function _min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }




}
