// Dependencies
import { expect } from 'chai';
import { ethers } from 'hardhat';

// Typings
import { ToysLegendERC721 } from '../../../typechain/ToysLegendERC721';
import { ToysLegendERC721__factory } from '../../../typechain/factories/ToysLegendERC721__factory';

// Tests
describe('ToysLegendERC721', () => {
  const name = 'Toys Legend Toy';
  const symbol = 'TOY';
  const type = 'TOY';

  let toysLegendERC721: ToysLegendERC721;
  let ToysLegendERC721: ToysLegendERC721__factory;

  beforeEach('Deploy ToysLegendERC721 Contract', async () => {
    // Deploy ToysLegendERC721 contract
    ToysLegendERC721 = await ethers.getContractFactory('ToysLegendERC721');
    toysLegendERC721 = await ToysLegendERC721.deploy(name, symbol, type);

    await toysLegendERC721.deployed();
  });

  it('Should return a valid tokenURI', async () => {
    const [deployer, account1] = await ethers.getSigners();

    const toysLegendERC721Signer = toysLegendERC721.connect(deployer);

    const safeMintTx = await toysLegendERC721Signer.safeMint(account1.address);

    await safeMintTx.wait();

    const tokenId = safeMintTx.value.toString();

    const { MORALIS_APP_ID = '', MORALIS_SERVER_URL = '' } = process.env;

    const endpoint = new URL('/server/functions/getNFT', MORALIS_SERVER_URL);

    endpoint.searchParams.append('_ApplicationId', MORALIS_APP_ID);
    endpoint.searchParams.append('type', type);
    endpoint.searchParams.append('tokenId', tokenId);

    const tokenURI = await toysLegendERC721Signer.tokenURI(tokenId);

    expect(tokenURI).to.be.equal(endpoint.toString());
  });

  it('Should mint a NFT if the caller has the role MINTER_ROLE', async () => {
    const [deployer, account1] = await ethers.getSigners();

    const toysLegendERC721Signer = toysLegendERC721.connect(deployer);

    const safeMintTx = await toysLegendERC721Signer.safeMint(account1.address);

    await safeMintTx.wait();

    const tokenId = safeMintTx.value.toString();

    const MINTER_ROLE = await toysLegendERC721.MINTER_ROLE();

    const hasMinterRole = await toysLegendERC721Signer.hasRole(
      MINTER_ROLE,
      deployer.address
    );

    expect(hasMinterRole).to.be.true;
    expect(safeMintTx)
      .to.emit(toysLegendERC721Signer, 'Transfer')
      .withArgs(ethers.constants.AddressZero, account1.address, tokenId);
  });

  it("Should revert the safeMint transaction if the caller hasn't the role MINTER_ROLE", async () => {
    const [_, account1] = await ethers.getSigners();

    const toysLegendERC721Signer = toysLegendERC721.connect(account1);

    const MINTER_ROLE = await toysLegendERC721.MINTER_ROLE();

    await expect(
      toysLegendERC721Signer.safeMint(account1.address)
    ).to.be.revertedWith(`is missing role ${MINTER_ROLE}`);
  });

  it('Should revert the safeMint transaction when the contract is paused', async () => {
    const [deployer] = await ethers.getSigners();

    const toysLegendERC721Signer = toysLegendERC721.connect(deployer);

    const pauseTx = await toysLegendERC721Signer.pause();

    expect(pauseTx)
      .to.emit(toysLegendERC721Signer, 'Paused')
      .withArgs(deployer.address);

    await expect(
      toysLegendERC721Signer.safeMint(deployer.address)
    ).to.be.revertedWith('Pausable: paused');
  });
});
