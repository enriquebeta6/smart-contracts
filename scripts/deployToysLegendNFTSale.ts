// Dependencies
import { ethers, network } from 'hardhat';

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log('network:', network.name);

  // Contracts address from mainnet
  let busdAddress = '0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56';
  let whiteListAddress = '0x4a554963C83CF30704aE2B4ae9C781E08cF2ceAC';

  if (['hardhat', 'localhost', 'testnet', 'goerli'].includes(network.name)) {
    const BUSDTokenMock = await ethers.getContractFactory('BUSDTokenMock');
    const busdTokenMock = await BUSDTokenMock.deploy();

    await busdTokenMock.deployed();

    busdAddress = busdTokenMock.address;

    console.log('BUSDTokenMock deployed to:', busdTokenMock.address);

    // Deploy WhiteList contract
    const ToysLegendWhiteList = await ethers.getContractFactory(
      'ToysLegendWhiteList'
    );
    const toysLegendWhiteList = await ToysLegendWhiteList.deploy();

    await toysLegendWhiteList.deployed();

    whiteListAddress = toysLegendWhiteList.address;

    console.log('WhiteList deployed to:', whiteListAddress);
  }

  // NFTs
  const [
    toy,
    card,
    land,
    skin,
    weapon,
    munitionFactory,
    batteryFactory,
    market,
  ] = await getNFTContracts();

  // Deploy NFTSale contract
  const NFTSale = await ethers.getContractFactory('NFTSale');
  const nftSale = await NFTSale.deploy(
    deployer.address,
    busdAddress,
    toy.address,
    card.address,
    land.address,
    skin.address,
    weapon.address,
    munitionFactory.address,
    batteryFactory.address,
    market.address
  );

  await nftSale.deployed();

  console.log('NFTSale deployed to:', nftSale.address);

  // Set whitelist contract address
  const setWhiteListTx = await nftSale.setWhiteList(whiteListAddress);

  await setWhiteListTx.wait();

  // Grant roles
  const MINTER_ROLE = await nftSale.MINTER_ROLE();
  const TRANSFER_ROLE = await nftSale.TRANSFER_ROLE();

  const promises = [
    toy,
    card,
    land,
    skin,
    weapon,
    munitionFactory,
    batteryFactory,
    market,
  ].map(async (contract) => {
    const tx1 = await contract.grantRole(MINTER_ROLE, nftSale.address);

    await tx1.wait();

    const tx2 = await contract.grantRole(TRANSFER_ROLE, nftSale.address);

    await tx2.wait();
  });

  await Promise.all(promises);
}

async function getNFTContracts() {
  // Deploy Card contract
  const Card = await ethers.getContractFactory('Card');
  const card = await Card.deploy();

  await card.deployed();

  console.log('Card deployed to:', card.address);

  // Deploy Skin contract
  const Skin = await ethers.getContractFactory('Skin');
  const skin = await Skin.deploy();

  await skin.deployed();

  console.log('Skin deployed to:', skin.address);

  // Deploy Toy contract
  const Toy = await ethers.getContractFactory('Toy');
  const toy = await Toy.deploy();

  await toy.deployed();

  console.log('Toy deployed to:', toy.address);

  // Deploy Weapon contract
  const Weapon = await ethers.getContractFactory('Weapon');
  const weapon = await Weapon.deploy();

  await weapon.deployed();

  console.log('Weapon deployed to:', weapon.address);

  // Deploy Land contract
  const Land = await ethers.getContractFactory('Land');
  const land = await Land.deploy();

  await land.deployed();

  console.log('Land deployed to:', land.address);

  // Deploy MunitionFactory contract
  const MunitionFactory = await ethers.getContractFactory('MunitionFactory');
  const munitionFactory = await MunitionFactory.deploy();

  await munitionFactory.deployed();

  console.log('MunitionFactory deployed to:', munitionFactory.address);

  // Deploy MunitionFactory contract
  const BatteryFactory = await ethers.getContractFactory('BatteryFactory');
  const batteryFactory = await BatteryFactory.deploy();

  await batteryFactory.deployed();

  console.log('BatteryFactory deployed to:', batteryFactory.address);

  // Deploy MunitionFactory contract
  const Market = await ethers.getContractFactory('Market');
  const market = await Market.deploy();

  await market.deployed();

  console.log('Market deployed to:', market.address);

  return [
    toy,
    card,
    land,
    skin,
    weapon,
    munitionFactory,
    batteryFactory,
    market,
  ];
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
