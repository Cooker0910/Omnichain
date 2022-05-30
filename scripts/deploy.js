const { ethers, network } = require('hardhat');
const hre = require('hardhat');
const LZ_ENDPOINTS = require("../constants/layerzeroEndpoints.json");

async function main () {
  const [deployer] = await ethers.getSigners();
  const networkName = hre.network.name;

  console.log("Deploying contracts with the account", deployer.address);

  console.log("Account balance", (await deployer.getBalance()).toString());

  const omniSticksFactory = await ethers.getContractFactory("OmniSticks");

  let omniSticksContract;

  switch(networkName) {
    case 'rinkeby':
      omniSticksContract = await omniSticksFactory.deploy("Omni Sticks Testnet", "STICKS", LZ_ENDPOINTS.rinkeby, 0, 749);
      break
    case 'mumbai':
      omniSticksContract = await omniSticksFactory.deploy("Omni Sticks Testnet", "STICKS", LZ_ENDPOINTS.mumbai, 750, 1499);
      break
    default:
      console.log("that is not a valid network name");
  }
  console.log("Token address:", omniSticksContract.address);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  })