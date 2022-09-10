import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.9",
    settings:{
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks:{
    kcc:{
      url: "https://rpc-mainnet.kcc.network",
      // 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 is 
      // a privatekey from hardhat 
      accounts: [process.env.DEPLOY_KEY || "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"]
    }
  },
};

export default config;
