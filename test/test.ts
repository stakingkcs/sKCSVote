import { expect } from "chai";
import { ethers } from "hardhat";
import { SKCSVoteToken } from "../typechain-types";

describe("solo",function () {

  it("solo", async function () {

    const snapBlock = 13390028;

    expect(
      await ethers.provider.getBlockNumber(),
      `This test case must be run by forking KCC mainnet at block later than ${snapBlock}!`
    ).gte(snapBlock);

    const impl = await(await ethers.getContractFactory("TestAggregator")).deploy();

    await expect(impl.testTorchesExchangeRate()).not.reverted;

    const voteToken = await (await ethers.getContractFactory("sKCSVoteToken")).deploy(impl.address) as SKCSVoteToken; 


    // check pair infos 
    for(let i=0; i< (await impl.lpInfosLength()).toNumber(); ++i){

        const {pair,masterChef,poolID,desc} = await impl.lpInfos(i);

        switch (pair) {

            case "0x42a82d898eB1d1688730709F4c2d99b537FEE308":
              {
                expect(masterChef,"0xfdfcE767aDD9dCF032Cbd0DE35F0E57b04495324");
                break;
              }
            case "0xA4e068d12ADCa07f99593E0133c6C01b01733ACf":
              {
                expect(masterChef,"0xfdfcE767aDD9dCF032Cbd0DE35F0E57b04495324");
                break;
              }
            case "0xbAa085B3C7E0eb30d75190609Fb0cb6E0Db56820":
              {
                expect(masterChef,"0xfdfcE767aDD9dCF032Cbd0DE35F0E57b04495324");
                break;
              }
            case "0x77A8d0eF377e7BCCDA40203aCce300C170017570":
              {
                expect(masterChef,"0x62974CE5d662f9045265716a3e64eaAfC258779F");
                break;
              }
            case "0xd8338546B0C7c07BA81F0dC3425fC4a25204756E":
              {
                expect(masterChef,"0x62974CE5d662f9045265716a3e64eaAfC258779F");
                break;
              }
            default:
              throw new Error(`missing cases`);
  
        }
    }

 
  });




});
