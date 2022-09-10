
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


/**
  * @title Compound's InterestRateModel Interface
  * @author Compound
  */
interface InterestRateModel {

    /**
      * @notice Calculates the current borrow interest rate per block
      * @param cash The total amount of cash the market has
      * @param borrows The total amount of borrows the market has outstanding
      * @param reserves The total amnount of reserves the market has
      * @return The borrow rate per block (as a percentage, and scaled by 1e18)
      */
    function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint);

    /**
      * @notice Calculates the current supply interest rate per block
      * @param cash The total amount of cash the market has
      * @param borrows The total amount of borrows the market has outstanding
      * @param reserves The total amnount of reserves the market has
      * @param reserveFactorMantissa The current reserve factor the market has
      * @return The supply rate per block (as a percentage, and scaled by 1e18)
      */
    function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);

}


interface ITorches is IERC20 {

    function totalBorrows() external view returns(uint);
    function totalReserves() external view returns(uint);
    function borrowIndex() external view returns(uint);    
    function accrualBlockNumber() external view returns(uint);
    function interestRateModel() external view returns(address);
    function reserveFactorMantissa() external view returns(uint);

    /// @dev This function mutates the state 
    function exchangeRateCurrent() external returns (uint);
}