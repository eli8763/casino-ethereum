require("@nomicfoundation/hardhat-toolbox");
module.exports = {
  solidity: {
    compilers: [
      { version: "0.5.17" },
      { version: "0.8.28" }
    ]
  },
  networks: {
    hardhat: {
      chainId: 31337
    }
  }
};
