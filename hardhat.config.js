require('@nomiclabs/hardhat-waffle');
require("@nomiclabs/hardhat-etherscan");
require('dotenv').config();

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task('accounts', 'Prints the list of accounts', async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 module.exports = {
  defaultNetwork: 'binanceMainnet',
  networks: {
    hardhat: {},
    binanceTestnet: {
      url: 'https://data-seed-prebsc-1-s1.binance.org:8545',
      chainId: 97,
      accounts: {mnemonic: process.env.MNEMONIC},
      live: true,
      saveDeployments: true
    },
    binanceMainnet: {
      url: 'https://bsc-dataseed.binance.org/',
      chainId: 56,
      accounts: {mnemonic: process.env.MNEMONIC},
      live: true,
      saveDeployments: true
    }
  },
  solidity: '0.8.0',
  settings: {
    optimizer: {
      enabled: true,
      runs: 2000
    }
  },
  etherscan: {
    apiKey: process.env.BINANCE_ETHERSCAN_API_KEY
  },
  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts'
  },
  mocha: {
    timeout: 200000
  }
};
