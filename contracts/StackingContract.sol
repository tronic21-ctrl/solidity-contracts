// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StakingContract {
    address public owner;
    // Token yang di-stake (pakai ETH langsung, tidak perlu ERC-20 dulu)
    mapping(address => uint256) public stakedAmount;    // berapa ETH yang di-stake tiap user
    mapping(address => uint256) public stakeTimestamp;  // kapan user mulai stake
    uint256 public rewardRatePerSecond = 1;             // reward per detik (dalam wei)
    uint256 public minimumStakePeriod = 60;             // minimum 60 detik sebelum bisa unstake
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount, uint256 reward);
    function stake() public payable {
    require(msg.value > 0, "Harus stake lebih dari 0 ETH");
    require(stakedAmount[msg.sender] == 0, "Sudah ada stake aktif");
    
    stakedAmount[msg.sender] = msg.value;
    stakeTimestamp[msg.sender] = block.timestamp;
    
    emit Staked(msg.sender, msg.value);
}

function calculateReward(address user) public view returns (uint256) {
    if (stakedAmount[user] == 0) return 0;
    
    uint256 duration = block.timestamp - stakeTimestamp[user];
    return duration * rewardRatePerSecond;
}

function unstake() public {
    require(stakedAmount[msg.sender] > 0, "tidak ada stake aktif");
    require(
        block.timestamp >= stakeTimestamp[msg.sender] + minimumStakePeriod,
        "minimum stake period belum tercapai"
    );

    uint256 amount = stakedAmount[msg.sender];
    uint256 reward = calculateReward(msg.sender);

    stakedAmount[msg.sender] = 0;
    stakeTimestamp[msg.sender] = 0;

    (bool success, ) = payable(msg.sender).call{value: amount + reward}("");
    require(success, "Transfer gagal");
    
    emit Unstaked(msg.sender, amount, reward);
}

function getStakeInfo(address user) public view returns (
    uint256 amount,
    uint256 timestamp,
    uint256 duration,
    uint256 reward
) {
    amount = stakedAmount[user];
    timestamp = stakeTimestamp[user];
    duration = timestamp > 0 ? block.timestamp - timestamp : 0;
    reward = calculateReward(user);
}
    
    constructor() {
        owner = msg.sender;
    }
}

