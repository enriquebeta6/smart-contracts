// Dependencies
import { expect } from 'chai';
import { ethers } from 'hardhat';

// Typings
import { ToysLegendCoin } from './../typechain/ToysLegendCoin.d';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { ToysLegendCoin__factory } from './../typechain/factories/ToysLegendCoin__factory';

// Tests
describe('ToysLegendCoin', () => {
  let toysLegendCoin: ToysLegendCoin;
  let ToysLegendCoin: ToysLegendCoin__factory;

  let rewardWallet: SignerWithAddress;
  let marketingWallet: SignerWithAddress;
  let operationsWallet: SignerWithAddress;
  let dynamicFlowWallet: SignerWithAddress;
  let developmentWallet: SignerWithAddress;

  beforeEach('Deploy Toys Legend Coin Contract', async () => {
    [
      rewardWallet,
      marketingWallet,
      operationsWallet,
      dynamicFlowWallet,
      developmentWallet,
    ] = await ethers.getSigners();

    ToysLegendCoin = await ethers.getContractFactory('ToysLegendCoin');
    toysLegendCoin = await ToysLegendCoin.deploy(
      rewardWallet.address,
      marketingWallet.address,
      operationsWallet.address,
      dynamicFlowWallet.address,
      developmentWallet.address
    );

    await toysLegendCoin.deployed();
  });

  it('Should distribute 35M of tokens to Reward Wallet', async () => {
    const supply = 35_000_000;

    const balance = await toysLegendCoin.balanceOf(rewardWallet.address);
    const supplyParsed = ethers.utils.parseEther(supply.toString());

    expect(balance).to.equal(supplyParsed);
  });

  it('Should distribute 1M of tokens to Marketing Wallet', async () => {
    const supply = 1_000_000;

    const balance = await toysLegendCoin.balanceOf(marketingWallet.address);
    const supplyParsed = ethers.utils.parseEther(supply.toString());

    expect(balance).to.equal(supplyParsed);
  });

  it('Should distribute 5M of tokens to Operation Wallet', async () => {
    const supply = 5_000_000;

    const balance = await toysLegendCoin.balanceOf(operationsWallet.address);
    const supplyParsed = ethers.utils.parseEther(supply.toString());

    expect(balance).to.equal(supplyParsed);
  });

  it('Should distribute 5M of tokens to Dynamic Flow Wallet', async () => {
    const supply = 5_000_000;

    const balance = await toysLegendCoin.balanceOf(dynamicFlowWallet.address);
    const supplyParsed = ethers.utils.parseEther(supply.toString());

    expect(balance).to.equal(supplyParsed);
  });

  it('Should distribute 4M of tokens to Development Wallet', async () => {
    const supply = 4_000_000;

    const balance = await toysLegendCoin.balanceOf(developmentWallet.address);
    const supplyParsed = ethers.utils.parseEther(supply.toString());

    expect(balance).to.equal(supplyParsed);
  });

  it('Should retrive the totalSupply equal to 50M', async () => {
    const totalSupply = 50_000_000;

    const currentTotalSupply = await toysLegendCoin.totalSupply();
    const totalSupplyParsed = ethers.utils.parseEther(totalSupply.toString());

    expect(currentTotalSupply).to.equal(totalSupplyParsed);
  });
});
