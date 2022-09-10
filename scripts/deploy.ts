import { ethers } from "hardhat";
import { SKCSVoteToken__factory } from "../typechain-types";
import { skcsVoteSol } from "../typechain-types/factories/contracts";

async function main() {

  //  const factory = await ethers.getContractFactory("Aggregator");
  //  const aggregator = await factory.deploy();

  //  console.log(`${aggregator.address}`);

  const token = await ((await ethers.getContractFactory("sKCSVoteToken"))).deploy("0x406874Ff08AcD5f5e6244E44029eFE1278175f9d");

  console.log(`${token.address}`);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
