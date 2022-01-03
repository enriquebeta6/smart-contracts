// Dependencies
import { expect } from 'chai';
import { ethers } from 'hardhat';

// Typings
import { BUSDTokenMock } from './../typechain/BUSDTokenMock.d';
import { BUSDTokenMock__factory } from './../typechain/factories/BUSDTokenMock__factory';

import { ToysLegendDonation } from './../typechain/ToysLegendDonation.d';
import { ToysLegendDonation__factory } from './../typechain/factories/ToysLegendDonation__factory';

import { ToysLegendWhiteList } from './../typechain/ToysLegendWhiteList.d';
import { ToysLegendWhiteList__factory } from './../typechain/factories/ToysLegendWhiteList__factory';

// Tests
describe('ToysLegendDonation', () => {
  let busdTokenMock: BUSDTokenMock;
  let BUSDTokenMock: BUSDTokenMock__factory;

  let toysLegendDonation: ToysLegendDonation;
  let ToysLegendDonation: ToysLegendDonation__factory;

  let toysLegendWhiteList: ToysLegendWhiteList;
  let ToysLegendWhiteList: ToysLegendWhiteList__factory;

  const maxNumberOfDonators = 1;
  const minimunContribution = ethers.utils.parseEther('25');

  beforeEach(
    'Deploy ToysLegendDonation Contract with their dependencies',
    async () => {
      const [deployer] = await ethers.getSigners();

      // Deploy BUSDTokenMock contract
      BUSDTokenMock = await ethers.getContractFactory('BUSDTokenMock');
      busdTokenMock = await BUSDTokenMock.deploy();

      await busdTokenMock.deployed();

      // Deploy ToysLegendWhiteList contract
      ToysLegendWhiteList = await ethers.getContractFactory(
        'ToysLegendWhiteList'
      );
      toysLegendWhiteList = await ToysLegendWhiteList.deploy();

      await toysLegendWhiteList.deployed();

      // Deploy ToysLegendDonation contract
      ToysLegendDonation = await ethers.getContractFactory(
        'ToysLegendDonation'
      );
      toysLegendDonation = await ToysLegendDonation.deploy(
        busdTokenMock.address,
        toysLegendWhiteList.address,
        deployer.address,
        minimunContribution,
        maxNumberOfDonators
      );

      await toysLegendDonation.deployed();

      const transferOwnershipTrasaction =
        await toysLegendWhiteList.transferOwnership(toysLegendDonation.address);

      await transferOwnershipTrasaction.wait();
    }
  );

  it('Should be owner of ToysLegendWhiteList contract', async () => {
    const toysLegendWhiteListOwner = await toysLegendWhiteList.owner();

    expect(toysLegendWhiteListOwner).to.be.equal(toysLegendDonation.address);
  });

  it('Should return the ownership to the deployer', async () => {
    const [deployer] = await ethers.getSigners();

    const oldOwner = await toysLegendWhiteList.owner();

    const returnOwnerToWhitelistTx =
      await toysLegendDonation.returnOwnerToWhitelist();
    await returnOwnerToWhitelistTx.wait();

    const newOwner = await toysLegendWhiteList.owner();

    expect(newOwner).not.equal(oldOwner);
    expect(deployer.address).to.be.equal(newOwner);
  });

  it('Should returns a successful donation', async () => {
    // The initial balances in BUSD of these accounts are:
    /// deployer = 1000
    /// sender = 4000
    const [deployer, sender] = await ethers.getSigners();

    const busdTokenMockSigner = busdTokenMock.connect(sender);
    const toysLegendDonationSigner = toysLegendDonation.connect(sender);

    const busdApproveTrasaction = await busdTokenMockSigner.approve(
      toysLegendDonation.address,
      minimunContribution
    );

    await busdApproveTrasaction.wait();

    const makeDonationTransaction =
      await toysLegendDonationSigner.makeDonation();

    await makeDonationTransaction.wait();

    const currentNumberOfDonors = await toysLegendDonation.numberOfDonators();

    const balanceOfDeployer = await busdTokenMock.balanceOf(deployer.address);
    const expectedBalanceOfDeployer = ethers.utils.parseEther('1025');

    const senderIsDonor = await toysLegendDonation.isDonator(sender.address);

    expect(makeDonationTransaction)
      .to.emit(toysLegendDonationSigner, 'AddedToDonors')
      .withArgs(sender.address);

    expect(senderIsDonor).to.be.true;
    expect(currentNumberOfDonors).to.be.equal(1);
    expect(balanceOfDeployer).to.be.equal(expectedBalanceOfDeployer);
  });

  it('Should be reverted when the maxNumberOfDonators is reached', async () => {
    // The initial balances in BUSD of these accounts are:
    /// deployer = 1000
    /// sender1 = 4000
    /// sender2 = 8000
    const [_, sender1, sender2] = await ethers.getSigners();

    // First sender1 approves the contract and make a donation
    const busdTokenMockSigner1 = busdTokenMock.connect(sender1);
    const toysLegendDonationSigner1 = toysLegendDonation.connect(sender1);

    const busdApproveTrasaction1 = await busdTokenMockSigner1.approve(
      toysLegendDonation.address,
      minimunContribution
    );

    await busdApproveTrasaction1.wait();

    const makeDonationTransaction1 =
      await toysLegendDonationSigner1.makeDonation();

    await makeDonationTransaction1.wait();

    // Second sender2 approves the contract and make a donation
    const busdTokenMockSigner2 = busdTokenMock.connect(sender2);
    const toysLegendDonationSigner2 = toysLegendDonation.connect(sender2);

    const busdApproveTrasaction2 = await busdTokenMockSigner2.approve(
      toysLegendDonation.address,
      minimunContribution
    );

    await busdApproveTrasaction2.wait();

    await expect(toysLegendDonationSigner2.makeDonation()).to.be.revertedWith(
      'Number of donators limit exceed'
    );
  });
});
