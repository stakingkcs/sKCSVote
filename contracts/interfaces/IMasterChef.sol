// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


interface IMasterChef {
    // Info of each user.
    struct UserInfo {
        uint256 amount;     // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
        //
        // We do some fancy math here. Basically, any point in time, the amount of MJTs
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accMojitoPerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
        //   1. The pool's `accMojitoPerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }

    /// @notice get the user's staking info of LP token 
    function userInfo(uint256 poolID, address user) external view returns(UserInfo memory);

}