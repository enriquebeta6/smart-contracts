// Dependencies
import { ethers } from 'hardhat';

// npx hardhat run --network localhost scripts/disableWhiteList.ts

async function main() {
  const [deployer] = await ethers.getSigners();

  const { NFT_SALE_ADDRESS = '' } = process.env;

  const NFTSale = await ethers.getContractFactory('NFTSale');
  const nftSale = NFTSale.attach(NFT_SALE_ADDRESS);

  const nftSaleSigner = nftSale.connect(deployer);

  const setWhitelistOnlyTx = await nftSaleSigner.setWhitelistOnly(false);

  await setWhitelistOnlyTx.wait();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
