// Dependencies
import { expect } from 'chai';
import { ethers } from 'hardhat';

// Typings
import { ToysLegendBlackList } from '../../../typechain/ToysLegendBlackList';
import { ToysLegendBlackList__factory } from '../../../typechain/factories/ToysLegendBlackList__factory';

// Tests
describe('ToysLegendBlackList', () => {
  let toysLegendBlackList: ToysLegendBlackList;
  let ToysLegendBlackList: ToysLegendBlackList__factory;

  beforeEach('Deploy ToysLegendBlacklist Contract', async () => {
    // Deploy ToysLegendBlackList contract
    ToysLegendBlackList = await ethers.getContractFactory(
      'ToysLegendBlackList'
    );
    toysLegendBlackList = await ToysLegendBlackList.deploy();

    await toysLegendBlackList.deployed();
  });

  it('Should add sender address to blacklist', async () => {
    const [_, sender] = await ethers.getSigners();

    await expect(toysLegendBlackList.add(sender.address))
      .to.emit(toysLegendBlackList, 'AddedToBlacklist')
      .withArgs(sender.address);

    const blacklistCount = await toysLegendBlackList.blacklistCount();
    const isBlacklistedTx = await toysLegendBlackList.blacklist(sender.address);

    expect(isBlacklistedTx).to.be.true;
    expect(blacklistCount).to.be.equal(1);
  });

  it('Should remove sender address from blacklist', async () => {
    const [_, sender] = await ethers.getSigners();

    const addTx = await toysLegendBlackList.add(sender.address);
    await addTx.wait();

    await expect(toysLegendBlackList.remove(sender.address))
      .to.emit(toysLegendBlackList, 'RemovedFromBlacklist')
      .withArgs(sender.address);

    const blacklistCount = await toysLegendBlackList.blacklistCount();
    const isBlacklistedTx = await toysLegendBlackList.blacklist(sender.address);

    expect(isBlacklistedTx).to.be.false;
    expect(blacklistCount).to.be.equal(0);
  });
});
