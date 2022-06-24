// Dependencies
import { expect } from 'chai';
import { ethers } from 'hardhat';

// Typings
import { ToysLegendWhiteList } from '../../../typechain/ToysLegendWhiteList';
import { ToysLegendWhiteList__factory } from '../../../typechain/factories/ToysLegendWhiteList__factory';

// Tests
describe('ToysLegendWhiteList', () => {
  let toysLegendWhiteList: ToysLegendWhiteList;
  let ToysLegendWhiteList: ToysLegendWhiteList__factory;

  beforeEach('Deploy ToysLegendWhiteList Contract', async () => {
    // Deploy ToysLegendWhiteList contract
    ToysLegendWhiteList = await ethers.getContractFactory(
      'ToysLegendWhiteList'
    );
    toysLegendWhiteList = await ToysLegendWhiteList.deploy();

    await toysLegendWhiteList.deployed();
  });

  it('Should add sender address to whitelist', async () => {
    const [_, sender] = await ethers.getSigners();

    await expect(toysLegendWhiteList.add(sender.address))
      .to.emit(toysLegendWhiteList, 'AddedToWhitelist')
      .withArgs(sender.address);

    const isWhitelistedTx = await toysLegendWhiteList.isWhitelisted(
      sender.address
    );

    expect(isWhitelistedTx).to.be.true;
  });

  it('Should remove sender address from whitelist', async () => {
    const [_, sender] = await ethers.getSigners();

    const addTx = await toysLegendWhiteList.add(sender.address);
    await addTx.wait();

    await expect(toysLegendWhiteList.remove(sender.address))
      .to.emit(toysLegendWhiteList, 'RemovedFromWhitelist')
      .withArgs(sender.address);

    const isWhitelistedTx = await toysLegendWhiteList.isWhitelisted(
      sender.address
    );

    expect(isWhitelistedTx).to.be.false;
  });
});
