// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IAggregator.sol";
import "./interfaces/IMasterChef.sol";
import "./interfaces/ITorches.sol";

import "hardhat/console.sol";

contract Aggregator is IAggregator {
    address public constant SKCS_ADDRESS =
        0x00eE2d494258D6C5A30d6B6472A09b27121Ef451;
    address public constant TSKCS_ADDRESS =
        0x0868713842d2e296CeF26c86d736AC7C374A5199;
    uint256 private constant _NO_POOL = 2**256 - 1;

    /// @notice the infomation of a pair from mojito/kuswap
    struct LPInfo {
        address pair; // the address of the pair
        address masterChef; // The masterchef address of the dex s
        uint256 poolID; // The pool id of the pair
        string desc; // description
    }

    LPInfo[] public lpInfos;

    constructor() {
        lpInfos.push(
            LPInfo(
                0x42a82d898eB1d1688730709F4c2d99b537FEE308,
                0xfdfcE767aDD9dCF032Cbd0DE35F0E57b04495324,
                _NO_POOL,
                "Mojito sKCS/MJT LP"
            )
        );

        lpInfos.push(
            LPInfo(
                0xA4e068d12ADCa07f99593E0133c6C01b01733ACf,
                0xfdfcE767aDD9dCF032Cbd0DE35F0E57b04495324,
                30,
                "Mojito KCS/sKCS LP"
            )
        );

        lpInfos.push(
            LPInfo(
                0xbAa085B3C7E0eb30d75190609Fb0cb6E0Db56820,
                0xfdfcE767aDD9dCF032Cbd0DE35F0E57b04495324,
                29,
                "Mojito sKCS/USDT LP"
            )
        );

        lpInfos.push(
            LPInfo(
                0x77A8d0eF377e7BCCDA40203aCce300C170017570,
                0x62974CE5d662f9045265716a3e64eaAfC258779F,
                16,
                "Kuswap KUS/sKCS LP"
            )
        );

        lpInfos.push(
            LPInfo(
                0xd8338546B0C7c07BA81F0dC3425fC4a25204756E,
                0x62974CE5d662f9045265716a3e64eaAfC258779F,
                _NO_POOL,
                "Kuswap KCS/sKCS LP"
            )
        );
    }

    function getUserSKCSHoldings(address user) external view returns (uint256) {
        uint256 amount = 0;

        // sKCS in user's wallet
        amount += IERC20(SKCS_ADDRESS).balanceOf(user);

        // Torches sKCS in user's wallet
        // And convert tsKCS to sKCS amount
        amount += getHoldingOnTorches(user);

        // Indirect holdings from Uniswap-like LPs
        for (uint i = 0; i < lpInfos.length; ++i) {
            LPInfo storage info = lpInfos[i];
            amount += getHoldingsOnUniswapLikePair(
                user,
                info.pair,
                info.masterChef,
                info.poolID
            );
        }

        return amount;
    }

    function getHoldingOnTorches(address user) public view returns (uint256) {
        ITorches tskcs = ITorches(TSKCS_ADDRESS);
        return (tskcs.balanceOf(user) * getTorchesSKCSExchangeRate()) / (1 ether);
    }

    /// @notice Get sKCS holdings on Uniswap-Like pair
    /// @param pair The uniswap-like(mojito/kuswap) pair
    /// @param masterchef The masterchef of the dex
    /// @param poolID The possible masterchef pool id of the pair,
    ///        a poolID of "-1" means that there is no pool for the pair.
    function getHoldingsOnUniswapLikePair(
        address user,
        address pair,
        address masterchef,
        uint256 poolID
    ) public view returns (uint256) {
        // LP amount held by the user

        // LP in user's wallet
        uint256 lpAmount = IERC20(pair).balanceOf(user);

        // User's LP in masterchef (i.e farming)
        if (poolID != _NO_POOL) {
            lpAmount += IMasterChef(masterchef).userInfo(poolID, user).amount;
        }

        // total sKCS in the pair
        uint256 totalSKCS = IERC20(SKCS_ADDRESS).balanceOf(pair);
        uint256 totalLP = IERC20(pair).totalSupply();

        return (lpAmount * totalSKCS) / totalLP;
    }

    // helper
    function lpInfosLength() external view returns (uint) {
        return lpInfos.length;
    }

    function getTorchesSKCSExchangeRate() public view returns(uint){

        ITorches tskcs = ITorches(TSKCS_ADDRESS);

        {
            // Unluckily, the "exchangeRateCurrent" function of ITorches mutates the state.
            // We would like to have a constant version of this function.
            // So, let's caculate the "current exchangeRate" by ourself.

            uint cashPrior = IERC20(SKCS_ADDRESS).balanceOf(TSKCS_ADDRESS);

            uint borrowsPrior = tskcs.totalBorrows();
            uint reservesPrior = tskcs.totalReserves();
            uint reserveFactorMantissa = tskcs.reserveFactorMantissa();
            uint borrowRateMantissa = InterestRateModel(
                tskcs.interestRateModel()
            ).getBorrowRate(cashPrior, borrowsPrior, reservesPrior);

            uint simpleInterestFactor = borrowRateMantissa *
                (block.number - tskcs.accrualBlockNumber());
            uint interestAccumulated = (simpleInterestFactor * borrowsPrior) /
                (1 ether);
            uint totalBorrows = interestAccumulated + borrowsPrior;
            uint totalReserves = (reserveFactorMantissa *
                interestAccumulated) /
                (1 ether) +
                reservesPrior;

            // exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
            return (cashPrior + totalBorrows - totalReserves) * (1 ether) / tskcs.totalSupply();
        }
    }

}


contract TestAggregator is Aggregator {

    function testTorchesExchangeRate() external{
        require(getTorchesSKCSExchangeRate() == ITorches(TSKCS_ADDRESS).exchangeRateCurrent(),"tsKCS exchange rate");
    }
}