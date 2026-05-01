// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ============================================
// INTERFACES — "daftar menu" dari contract lain
// ============================================

interface IStaking {
    function getStakeInfo(address user) external view returns (
        uint256 amount,
        uint256 timestamp,
        uint256 duration,
        uint256 reward
    );
}

interface IGovernance {
    function createProposal(string memory description) external returns (uint256);
    function vote(uint256 proposalId, bool support) external;
    function getProposal(uint256 proposalId) external view returns (
        uint256 id,
        address proposer,
        string memory description,
        uint256 yesVotes,
        uint256 noVotes,
        uint256 deadline,
        bool executed,
        bool passed
    );
}

// ============================================
// MAIN CONTRACT
// ============================================

contract StakingGovernance {
    address public owner;
    IStaking public stakingContract;
    IGovernance public governanceContract;

    uint256 public minimumStakeToVote = 0.001 ether; // minimum stake untuk bisa vote
    event VoteCast(address indexed voter, uint256 proposalId, bool support, uint256 stakedAmount);
    event ProposalCreatedBy(address indexed creator, uint256 proposalId, uint256 stakedAmount);

    constructor(address _stakingContract, address _governanceContract) {
        owner = msg.sender;
        stakingContract = IStaking(_stakingContract);
        governanceContract = IGovernance(_governanceContract);
    }

    // Modifier: cek apakah user punya stake yang cukup
    modifier onlyStaker() {
        (uint256 amount,,,) = stakingContract.getStakeInfo(msg.sender);
        require(amount >= minimumStakeToVote, "Harus stake dulu untuk bisa berpartisipasi");
        _;
    }

    // Buat proposal — hanya user yang sudah stake
    function createProposalAsStaker(string memory description) public onlyStaker returns (uint256) {
        (uint256 amount,,,) = stakingContract.getStakeInfo(msg.sender);

        uint256 proposalId = governanceContract.createProposal(description);

        emit ProposalCreatedBy(msg.sender, proposalId, amount);
        return proposalId;
    }

    // Vote — hanya user yang sudah stake
    function voteAsStaker(uint256 proposalId, bool support) public onlyStaker{
        (uint256 amount,,,) = stakingContract.getStakeInfo(msg.sender);

        governanceContract.vote(proposalId, support);
        emit VoteCast(msg.sender, proposalId, support, amount);
    }

    // Baca info proposal langsung dari GovernanceContract
    function getProposalInfo(uint256 proposalId) public view returns (
        uint256 id,
        address proposer,
        string memory description,
        uint256 yesVotes,
        uint256 noVotes,
        uint256 deadline,
        bool executed,
        bool passed
    ) {
        return governanceContract.getProposal(proposalId);
    }

    // Cek apakah user eligible untuk vote
    function checkEligibility(address user) public view returns (
        bool eligible,
        uint256 stakedAmount
    ) {
        (uint256 amount,,,) = stakingContract.getStakeInfo(user);
        eligible = amount >= minimumStakeToVote;
        stakedAmount = amount;
    }
}