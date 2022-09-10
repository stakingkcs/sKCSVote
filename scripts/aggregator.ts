import { ethers } from "hardhat";

async function main() {


    const block = 13411074;
    
    const blockInfo = await ethers.provider.getBlock(block);
    if (blockInfo == null || blockInfo.hash != "0xb1e17929ea0c4b3e6318cd8cf8c5197717a4809d92c556004204a4f47be6d82d"){
         throw new Error("This script must be run against KCC mainnet");
    }

   const address = "0x406874Ff08AcD5f5e6244E44029eFE1278175f9d";
   const mathew = "0xB066b83AF38778153C475AFd3ADc0189Ec8c780F";
   const aggregator = await ethers.getContractAt("Aggregator",address);



   const blockTag = {blockTag:block};

    console.log(`Torches Conversion Rate: ${await aggregator.getTorchesSKCSExchangeRate(blockTag)
    }\nUser's sKCS amount from Torches:${
        await aggregator.getHoldingOnTorches(mathew,blockTag)
    }\n`);

    for(let i =0; i < (await aggregator.lpInfosLength(blockTag)).toNumber();++i){

        const {pair,masterChef,poolID,desc} = await aggregator.lpInfos(i,blockTag);

        console.log(`sKCS in ${desc}: ${(await aggregator.getHoldingsOnUniswapLikePair(
            mathew,
            pair,
            masterChef,
            poolID,
            blockTag
        )).toString()}`);
    }


    console.log(`User's direct and indirect sKCS holdings: ${await aggregator.getUserSKCSHoldings(mathew,blockTag)}`)


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
