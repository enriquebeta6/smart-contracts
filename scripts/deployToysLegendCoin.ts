import { ethers } from 'hardhat';

async function main() {
  const [wallet] = await ethers.getSigners();

  // Hardhat always runs the compile task when running scripts with its command
  // line interface.

  // We get the contract to deploy
  const ToysLegendCoin = await ethers.getContractFactory('ToysLegendCoin');
  const toysLegendCoin = await ToysLegendCoin.deploy(wallet.address);

  await toysLegendCoin.deployed();

  console.log('ToysLegendCoin deployed to:', toysLegendCoin.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
