// Dependencies
import { ethers, network } from 'hardhat';

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.

  // BUSD address for mainnet
  let busdAddress = '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56';

  console.log('network:', network.name);

  if (['hardhat', 'localhost'].includes(network.name)) {
    const BUSDTokenMock = await ethers.getContractFactory('BUSDTokenMock');
    const busdTokenMock = await BUSDTokenMock.deploy();

    await busdTokenMock.deployed();

    busdAddress = busdTokenMock.address;

    console.log('BUSDTokenMock deployed to:', busdTokenMock.address);
  }

  if (network.name === 'testnet') {
    busdAddress = '0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee';
  }

  // 1. Deploy the Toys Legend Whitelist contract

  const ToysLegendWhiteList = await ethers.getContractFactory(
    'ToysLegendWhiteList'
  );
  const toysLegendWhiteList = await ToysLegendWhiteList.deploy();

  await toysLegendWhiteList.deployed();

  console.log('ToysLegendWhiteList deployed to:', toysLegendWhiteList.address);

  // 2. Deploy the Toys Legend Donation contract
  const maxNumberOfDonators = 2500;

  const walletOfDonations = '0xa702D5410557788E84C1E1F4F823497e6838884C';

  const ToysLegendDonation = await ethers.getContractFactory(
    'ToysLegendDonation'
  );
  const toysLegendDonation = await ToysLegendDonation.deploy(
    busdAddress,
    toysLegendWhiteList.address,
    walletOfDonations,
    ethers.utils.parseEther('1'),
    maxNumberOfDonators
  );

  await toysLegendDonation.deployed();

  console.log('ToysLegendDonation deployed to:', toysLegendDonation.address);

  await toysLegendWhiteList.transferOwnership(toysLegendDonation.address);

  console.log(
    'ToysLegendWhiteList transfer ownership to:',
    toysLegendDonation.address
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
