# The sKCS Vote Token 

The `sKCSVoteToken` is **not a real** ERC20 Token, it is a wrapper token for getting a user's direct and indirect holdings of sKCS. By saying `indirect holdings`, we mean the sKCS held indirectly by holding `TorchesSKCS tokens` and `Kuswap/Mojitoswap LP tokens`.

The `sKCSVoteToken` is mainly or solely used on "snapshot.org" for calculating a user's voting power. You cannot transfer sKCSVoteToken. Your balance of sKCSVoteToken only reflects the total sKCS held directly and indirectly by you.

And here is a sample proposal on snapshot you can play with: [The test proposal](https://snapshot.org/#/matheww.eth/proposal/0x7c3c044684c48952e1134e03a9883fbe009d5886c1d07bae7eac40c1a6577e6d).

## Deployed Contract On KCC mainnet 

- [Aggregator](https://scan.kcc.io/address/0x406874Ff08AcD5f5e6244E44029eFE1278175f9d)   
- [sKCSVoteToken](https://scan.kcc.io/address/0xA79ADD56ce12AE8C4eBd82b5A3f34Aa5504DD0bC)  

## Details 

`Direct Holdings`: The sKCS in your wallet  
`Indirect Holdings`: 
  - Indirect holding by holding Torches SKCS token (i.e supply sKCS on torches)  
  - Indirect holding by holding Mojito LP tokens(i.e Add liquidity to Mojito, including farming with your LP)s 
  - Indirect holding by holding Kuswap LP tokens (i.e Add liquidity to Kuswap, including farming with your LP)
