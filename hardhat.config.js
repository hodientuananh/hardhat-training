require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  defaultNetwork: "sepolia",
  networks: {
    hardhat: {
    },
    sepolia: {
      url: "https://sepolia.infura.io/v3/69f6377b9c874b428d82983a41a2c348",
      accounts: ["00a69472a213537ad4d7012d482e6624fc4a96469caa8459c8a04893071734dd"]
    }
  },
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 40000
  }
}