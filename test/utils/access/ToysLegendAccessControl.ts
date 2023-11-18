// Dependencies
import { expect } from 'chai';
import { ethers } from 'hardhat';

// Typings
import { ToysLegendBlackList } from '../../../typechain/ToysLegendBlackList';
import { ToysLegendBlackList__factory } from '../../../typechain/factories/ToysLegendBlackList__factory';

import { ToysLegendWhiteList } from '../../../typechain/ToysLegendWhiteList';
import { ToysLegendWhiteList__factory } from '../../../typechain/factories/ToysLegendWhiteList__factory';

import { ToysLegendAccessControl } from '../../../typechain/ToysLegendAccessControl';
import { ToysLegendAccessControl__factory } from '../../../typechain/factories/ToysLegendAccessControl__factory';

// Tests
describe('ToysLegendAccessControl', () => {
  let toysLegendBlackList: ToysLegendBlackList;
  let ToysLegendBlackList: ToysLegendBlackList__factory;

  let toysLegendWhiteList: ToysLegendWhiteList;
  let ToysLegendWhiteList: ToysLegendWhiteList__factory;

  let toysLegendAccessControl: ToysLegendAccessControl;
  let ToysLegendAccessControl: ToysLegendAccessControl__factory;

  beforeEach('Deploy ToysLegendAccessControl Contract', async () => {
    const [deployer] = await ethers.getSigners();

    // Deploy ToysLegendBlackList contract
    ToysLegendBlackList = await ethers.getContractFactory(
      'ToysLegendBlackList'
    );
    toysLegendBlackList = await ToysLegendBlackList.deploy();

    await toysLegendBlackList.deployed();

    // Deploy ToysLegendWhiteList contract
    ToysLegendWhiteList = await ethers.getContractFactory(
      'ToysLegendWhiteList'
    );
    toysLegendWhiteList = await ToysLegendWhiteList.deploy();

    await toysLegendWhiteList.deployed();

    // Deploy ToysLegendAccessControl contract
    ToysLegendAccessControl = await ethers.getContractFactory(
      'ToysLegendAccessControl'
    );
    toysLegendAccessControl = await ToysLegendAccessControl.deploy();

    await toysLegendAccessControl.deployed();

    const toysLegendAccessControlSigner =
      toysLegendAccessControl.connect(deployer);

    const setWhiteListTx = await toysLegendAccessControlSigner.setWhiteList(
      toysLegendWhiteList.address
    );

    await setWhiteListTx.wait();

    const setBlackListTx = await toysLegendAccessControlSigner.setBlackList(
      toysLegendBlackList.address
    );

    await setBlackListTx.wait();
  });

  it('Should return true if an account is blacklisted through ToysLegendAccessControl', async () => {
    const [_, account1] = await ethers.getSigners();

    await toysLegendBlackList.add(account1.address);

    const isBlacklistedTx = await toysLegendAccessControl.isBlacklisted(
      account1.address
    );

    expect(isBlacklistedTx).to.be.true;
  });

  it('Should return true if an account is whitelisted through ToysLegendAccessControl', async () => {
    const [_, account1] = await ethers.getSigners();

    await toysLegendWhiteList.add(account1.address);

    const isWhitelistedTx = await toysLegendAccessControl.isWhitelisted(
      account1.address
    );

    expect(isWhitelistedTx).to.be.true;
  });
});
