// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IAggregator.sol";

/// @title sKCSVoteToken 
/// @dev This is not a real ERC20 token but a wrapper for getting a user's
/// direct and indirect(in dapps) sKCS holdings. This contract is mainly used by proposals on "snapshot.org". 
/// A user's voting power is his balance of the sKCSVoteToken. 
contract sKCSVoteToken is IERC20Metadata,Ownable {

    string public name = "sKCS Vote Token"; 
    string public symbol = "vSKCS";
    uint8  public decimals = 18; 
    uint248 private _alignment =0;
    IAggregator public  impl; 


    constructor(address _impl){
        impl = IAggregator(_impl);
    }

    /// @notice Managed by the gnosis safe of sKCS 
    function changeImpl(address _newImpl) external onlyOwner{
        impl = IAggregator(_newImpl);
    }

    function balanceOf(address account) external view returns (uint256){
        return impl.getUserSKCSHoldings(account);
    }

    // unused ERC20 methods 

    function transfer(address, uint256) external pure returns (bool){
        _unused();
    }
    function allowance(address, address) external pure returns (uint256){
        _unused();
    }
    function approve(address, uint256) external pure returns (bool){
        _unused();
    }
    function transferFrom(address,address,uint256) external pure returns (bool){
        _unused();
    }
    function totalSupply() external pure returns (uint256){
        _unused();
    }

    function _unused() internal pure{
        revert("not implemented");
    }
}
