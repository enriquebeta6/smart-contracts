// Dependencies
import { ethers } from 'hardhat';

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.

  const ToysLegendBlacklist = await ethers.getContractFactory(
    'ToysLegendBlacklist'
  );
  const toysLegendBlacklist = await ToysLegendBlacklist.deploy();

  await toysLegendBlacklist.deployed();

  console.log('ToysLegendBlacklist deployed to:', toysLegendBlacklist.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
