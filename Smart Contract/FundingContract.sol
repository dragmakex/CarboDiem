// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../contracts/EscrowContract.sol";

contract FundingContract {
    address public owner;
    IERC20 public stablecoin;
    uint256 public fundingGoal;
    uint256 public totalFunds;
    uint256 public numberOfCarbonCredits;
    uint256 public timeForFundingCampaign;
    uint256 public runtimeOfProjectToBeFunded;
    address public projectContract;
    address public carbonCreditProducer;

    mapping(address => uint256) public deposits;
    bool public goalReached;

    event Deposit(address indexed from, uint256 amount);
    event GoalReached(uint256 totalFunds);

    constructor(address _stablecoin, uint256 _goal, uint256 _timeForFundingCampaign, address _carbonCreditProducer) {
        owner = msg.sender;
        stablecoin = IERC20(_stablecoin);
        fundingGoal = _goal;
        totalFunds = 0;
        goalReached = false;
        projectContract = address(0);
        carbonCreditProducer = _carbonCreditProducer;
    }

    // Modifier to ensure that only the contract owner can perform certain actions.
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Function to allow users to deposit stablecoins.
    function deposit(uint256 amount) external {
        require(!goalReached, "Goal has already been reached.");
        require(stablecoin.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        deposits[msg.sender] += amount;
        totalFunds += amount;
        emit Deposit(msg.sender, amount);
        if (totalFunds >= fundingGoal) {
            goalReached = true;
            emit GoalReached(totalFunds);
            deployEscrowedContract();
        }
    }

    // Function to withdraw funds if the funding goal is not reached.
    function cancelFunding() external {


    }

    // function that mints the carbon credits and locks them together with the collected stablecoins in an escrow
    function deployEscrowedContract() internal {
         require(goalReached, "Goal has not been reached yet.");
         require(projectContract == address(0), "Project contract already deployed");

         EscrowContract newEscrow = new EscrowContract();
    }
}
