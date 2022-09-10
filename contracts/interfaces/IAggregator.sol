
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IAggregator {
    /// @notice Get the sKCS amount that is directly and indirectly held by the user. 
    function getUserSKCSHoldings(address user) external view returns(uint256 amount);
}