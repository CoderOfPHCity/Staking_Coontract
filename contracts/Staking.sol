// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./IERC20.sol";

contract Staking {
    struct Staker {
        uint256 amountStaked;
        uint256 reward;
        uint256 timeStaked;
    }

    address public DanielToken;

    constructor(address _DanielToken) {
        DanielToken = _DanielToken;
    }

    mapping(address => Staker) stakers;

    function stake(uint256 _amount) public {
        require(_amount > 0, "Amount must be greater than 0");
        require(
            IERC20(DanielToken).transferFrom(
                msg.sender,
                address(this),
                _amount
            ),
            "Transfer failed"
        );
        if (stakers[msg.sender].amountStaked == 0) {
            stakers[msg.sender] = Staker(_amount, 0, block.timestamp);
        } else {
            stakers[msg.sender].amountStaked += _amount;
        }
    }

    function calcReward() public {
        require(
            block.timestamp >= stakers[msg.sender].timeStaked + 1 days,
            "Cannot claim rewards yet"
        );
        uint256 rewardAmount = (stakers[msg.sender].amountStaked * 10) / 100;

        require(
            IERC20(DanielToken).transfer(msg.sender, rewardAmount),
            "Reward transfer failed"
        );
        stakers[msg.sender].timeStaked = block.timestamp;
        stakers[msg.sender].reward += rewardAmount;
    }

    function getAllRewards() public view returns (uint256 total) {
        return stakers[msg.sender].reward;
    }
}