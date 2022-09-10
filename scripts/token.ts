import { ethers } from "hardhat";
import { SKCSVoteToken } from "../typechain-types";

async function main() {


    const block = 13412584;
    
    const blockInfo = await ethers.provider.getBlock(block);
    if (blockInfo == null || blockInfo.hash != "0xbd9565a285f93ebcfd2fe99d3f466126b5f29bc27791769de4226e5d3a11980f"){
         throw new Error("This script must be run against KCC mainnet");
    }

   const aggregatorAddr = "0x406874Ff08AcD5f5e6244E44029eFE1278175f9d";
   const tokenAddr = "0xA79ADD56ce12AE8C4eBd82b5A3f34Aa5504DD0bC";
   const mathew = "0xB066b83AF38778153C475AFd3ADc0189Ec8c780F";
   const aggregator = await ethers.getContractAt("Aggregator",aggregatorAddr);
   const token = await ethers.getContractAt("sKCSVoteToken",tokenAddr) as SKCSVoteToken;
   
   
   const blockTag = {blockTag:block};


   console.log(`Get From Aggregator: ${await aggregator.getUserSKCSHoldings(mathew,blockTag)}`);
   console.log(`Get From Token: ${await token.balanceOf(mathew,blockTag)}`);



}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
