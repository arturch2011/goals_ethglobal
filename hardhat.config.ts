import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-verify";
import "dotenv/config";

const config: HardhatUserConfig = {
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.PROJECT_ID}` || "",
      chainId: 11155111,
      accounts: [process.env.PRIVATE_KEY || ""],
    },

    amoy: {
      url: `https://polygon-amoy.infura.io/v3/${process.env.PROJECT_ID}` || "",
      chainId: 80002,
      accounts: {
        mnemonic: process.env.MNEMONIC || "",
      },
    },

    polygon: {
      url: `https://polygon-mainnet.infura.io/v3/${process.env.PROJECT_ID}` || "",
      chainId: 137,
      accounts: {
        mnemonic: process.env.MNEMONIC || "",
      },
    },
  },


  etherscan: {
    apiKey: {
      amoy: process.env.ETHERSCAN_API_KEY || "",
      polygon: process.env.ETHERSCAN_API_KEY || "",
    },
    customChains: [
      {
        network: "amoy",
        chainId: 80002,
        urls: {
          apiURL: "https://api-amoy.polygonscan.com/api",
          browserURL: "https://amoy.polygonscan.com/"
        }
      }
    ]
  },

  sourcify: {
    enabled: false,
  },
  
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
      viaIR: true,
    },
  },

};

export default config;
