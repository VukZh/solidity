/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-toolbox");
require("hardhat-gas-reporter");
require('dotenv').config();

module.exports = {
  solidity: "0.8.23",
  networks: {
    sepolia: {
      url: "https://ethereum-sepolia.publicnode.com",
      accounts: [
        process.env.KEY,
      ],
    },
  },
  etherscan: {
    apiKey: {
      sepolia: "RA39WKFGYE13BSEYBJ4GVQCM2S8H6X9IS7",
    }
  },
  gasReporter: {
    enabled: (process.env.REPORT_GAS) ? true : false
  }
};
