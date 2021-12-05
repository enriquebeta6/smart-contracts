// Dependencies
import { expect } from 'chai';
import { ethers } from 'hardhat';

// Typings
import { ToysLegendCoin } from './../typechain/ToysLegendCoin.d';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { ToysLegendCoin__factory } from './../typechain/factories/ToysLegendCoin__factory';

// Tests
describe('ToysLegendCoin', () => {
  let wallet: SignerWithAddress;
  let toysLegendCoin: ToysLegendCoin;
  let ToysLegendCoin: ToysLegendCoin__factory;

  beforeEach('Deploy Toys Legend Coin Contract', async () => {
    [wallet] = await ethers.getSigners();

    ToysLegendCoin = await ethers.getContractFactory('ToysLegendCoin');
    toysLegendCoin = await ToysLegendCoin.deploy(wallet.address);

    await toysLegendCoin.deployed();
  });

  it('Should returns the total supply equal to 50M', async () => {
    const totalSupply = 50_000_000;

    const balance = await toysLegendCoin.balanceOf(wallet.address);
    const totalSupplyParsed = ethers.utils.parseEther(totalSupply.toString());

    expect(balance).to.equal(totalSupplyParsed);
  });
});
