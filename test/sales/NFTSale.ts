// Dependencies
import { expect } from 'chai';
import { ethers } from 'hardhat';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';

// Typings
import { NFTSale } from '../../typechain/NFTSale.d';
import { NFTSale__factory } from '../../typechain/factories/NFTSale__factory';

import { BUSDTokenMock } from '../../typechain/BUSDTokenMock.d';
import { BUSDTokenMock__factory } from '../../typechain/factories/BUSDTokenMock__factory';

import { ToysLegendWhiteList } from '../../typechain/ToysLegendWhiteList.d';
import { ToysLegendWhiteList__factory } from '../../typechain/factories/ToysLegendWhiteList__factory';

// NFTs
import { Card } from '../../typechain/Card.d';
import { Card__factory } from '../../typechain/factories/Card__factory';

import { Land } from '../../typechain/Land.d';
import { Land__factory } from '../../typechain/factories/Land__factory';

import { Skin } from '../../typechain/Skin.d';
import { Skin__factory } from '../../typechain/factories/Skin__factory';

import { Toy } from '../../typechain/Toy.d';
import { Toy__factory } from '../../typechain/factories/Toy__factory';

import { Weapon } from '../../typechain/Weapon.d';
import { Weapon__factory } from '../../typechain/factories/Weapon__factory';

import { MunitionFactory } from '../../typechain/MunitionFactory.d';
import { MunitionFactory__factory } from '../../typechain/factories/MunitionFactory__factory';

import { BatteryFactory } from '../../typechain/BatteryFactory.d';
import { BatteryFactory__factory } from '../../typechain/factories/BatteryFactory__factory';

import { Market } from '../../typechain/Market.d';
import { Market__factory } from '../../typechain/factories/Market__factory';

interface Item {
  nft: string;
  variation: number;
  quantity: number;
}

interface LandsToBuyFromPixel {
  y: number;
  x: number;
  positions: number[];
}

// Tests
describe('NFTSale', () => {
  let wallet: SignerWithAddress;
  let busdTokenMock: BUSDTokenMock;
  let BUSDTokenMock: BUSDTokenMock__factory;

  let toysLegendWhiteList: ToysLegendWhiteList;
  let ToysLegendWhiteList: ToysLegendWhiteList__factory;

  let nftSale: NFTSale;
  let NFTSale: NFTSale__factory;

  let card: Card;
  let Card: Card__factory;

  let skin: Skin;
  let Skin: Skin__factory;

  let toy: Toy;
  let Toy: Toy__factory;

  let weapon: Weapon;
  let Weapon: Weapon__factory;

  let land: Land;
  let Land: Land__factory;

  let munitionFactory: MunitionFactory;
  let MunitionFactory: MunitionFactory__factory;

  let batteryFactory: BatteryFactory;
  let BatteryFactory: BatteryFactory__factory;

  let market: Market;
  let Market: Market__factory;

  beforeEach('Deploy contract with their dependencies', async () => {
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

    // Deploy Card contract
    Card = await ethers.getContractFactory('Card');
    card = await Card.deploy();

    await card.deployed();

    // Deploy Skin contract
    Skin = await ethers.getContractFactory('Skin');
    skin = await Skin.deploy();

    await skin.deployed();

    // Deploy Toy contract
    Toy = await ethers.getContractFactory('Toy');
    toy = await Toy.deploy();

    await toy.deployed();

    // Deploy Weapon contract
    Weapon = await ethers.getContractFactory('Weapon');
    weapon = await Weapon.deploy();

    await weapon.deployed();

    // Deploy Land contract
    Land = await ethers.getContractFactory('Land');
    land = await Land.deploy();

    await land.deployed();

    // Deploy MunitionFactory contract
    MunitionFactory = await ethers.getContractFactory('MunitionFactory');
    munitionFactory = await MunitionFactory.deploy();

    await munitionFactory.deployed();

    // Deploy BatteryFactory contract
    BatteryFactory = await ethers.getContractFactory('BatteryFactory');
    batteryFactory = await BatteryFactory.deploy();

    await batteryFactory.deployed();

    // Deploy Market contract
    Market = await ethers.getContractFactory('Market');
    market = await Market.deploy();

    await market.deployed();

    // TODO: change wallet
    [wallet] = await ethers.getSigners();

    // Deploy NFTSale contract
    NFTSale = await ethers.getContractFactory('NFTSale');
    nftSale = await NFTSale.deploy(
      wallet.address,
      busdTokenMock.address,
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

    // Add ToysLegendWhitelist contract address to ToysLegendAccessControl
    const setWhiteListTx = await nftSale.setWhiteList(
      toysLegendWhiteList.address
    );

    await setWhiteListTx.wait();

    // Grant roles
    const MINTER_ROLE = await nftSale.MINTER_ROLE();
    const TRANSFER_ROLE = await nftSale.TRANSFER_ROLE();

    const promises = [
      card,
      skin,
      toy,
      weapon,
      land,
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
  });

  async function executeBuyItemsTransaction(items: Item[]) {
    const [, buyer] = await ethers.getSigners();

    const ToysLegendERC721 = await ethers.getContractFactory(
      'ToysLegendERC721'
    );

    // Bind signer wallet to contracts
    const busdSigner = busdTokenMock.connect(buyer);
    const nftSaleSigner = nftSale.connect(buyer);

    // Get total price of items
    const totalPrice = await nftSale.getTotalPriceFromItems(items);

    // Approve totalPrice in order to transfer the funds
    await busdSigner.increaseAllowance(nftSale.address, totalPrice);

    await expect(() => nftSaleSigner.buyItems(items)).to.changeTokenBalances(
      busdTokenMock,
      [buyer, wallet],
      [
        // Transform totalPrice to negative value
        ethers.BigNumber.from(totalPrice).mul(-1),
        totalPrice,
      ]
    );

    for (const item of items) {
      const address = await nftSale.NFTAddresses(item.nft);

      const contract = ToysLegendERC721.attach(address);

      const balance = await contract.balanceOf(buyer.address);

      expect(balance).to.be.equal(item.quantity);
    }
  }

  async function executeBuyLandsTransaction(pixels: LandsToBuyFromPixel[]) {
    const [, buyer] = await ethers.getSigners();

    // Bind signer wallet to contracts
    const busdSigner = busdTokenMock.connect(buyer);
    const nftSaleSigner = nftSale.connect(buyer);

    // Get total price of lands
    const totalPrice = await nftSale.getTotalPriceFromLands(pixels);

    // Approve totalPrice in order to transfer the funds
    await busdSigner.approve(nftSale.address, totalPrice);

    await expect(() => nftSaleSigner.buyLands(pixels)).to.changeTokenBalances(
      busdTokenMock,
      [buyer, wallet],
      [
        // Transform totalPrice to negative value
        ethers.BigNumber.from(totalPrice).mul(-1),
        totalPrice,
      ]
    );

    const totalQuantity = pixels.reduce(
      (acc, pixel) => acc + pixel.positions.length,
      0
    );

    const balance = await land.balanceOf(buyer.address);

    expect(balance).to.be.equal(totalQuantity);
  }

  describe('getTotalPriceFromItems', () => {
    it('Should return correct price', async () => {
      const items1: Item[] = [
        {
          quantity: 10,
          nft: 'CARD',
          variation: 1,
        },
      ];

      const items2: Item[] = [
        {
          quantity: 10,
          nft: 'CARD',
          variation: 1,
        },
        {
          quantity: 10,
          nft: 'CARD',
          variation: 3,
        },
        {
          quantity: 10,
          nft: 'CARD',
          variation: 4,
        },
      ];

      const items1Prices = await Promise.all(
        items1.map(async (item) => {
          const tempPrice = await nftSale.priceByNFTAndVariation(
            item.nft,
            item.variation
          );

          return tempPrice.mul(item.quantity);
        })
      );

      const items1TotalPrice = items1Prices.reduce(
        (acc, curr) => acc.add(curr),
        ethers.BigNumber.from(0)
      );

      const items2Prices = await Promise.all(
        items2.map(async (item) => {
          const tempPrice = await nftSale.priceByNFTAndVariation(
            item.nft,
            item.variation
          );

          return tempPrice.mul(item.quantity);
        })
      );

      const items2TotalPrice = items2Prices.reduce(
        (acc, curr) => acc.add(curr),
        ethers.BigNumber.from(0)
      );

      const total1 = await nftSale.getTotalPriceFromItems(items1);

      expect(total1).to.be.equal(items1TotalPrice);

      const total2 = await nftSale.getTotalPriceFromItems(items2);

      expect(total2).to.be.equal(items2TotalPrice);
    });

    it('Should revert if the user send wrong items', async () => {
      const itemsWithWrongNFT: Item[] = [
        {
          quantity: 10,
          nft: 'WRONG_NFT',
          variation: 1,
        },
      ];

      const itemsWithWrongVariation: Item[] = [
        {
          quantity: 10,
          nft: 'CARD',
          variation: 30,
        },
      ];

      await expect(
        nftSale.getTotalPriceFromItems(itemsWithWrongNFT)
      ).to.be.revertedWith('NFTSale: price must be greater than 0');

      await expect(
        nftSale.getTotalPriceFromItems(itemsWithWrongVariation)
      ).to.be.revertedWith('NFTSale: price must be greater than 0');
    });
  });

  describe('validateItems', () => {
    it('Should not revert', async () => {
      const items1: Item[] = [
        {
          quantity: 10,
          nft: 'CARD',
          variation: 1,
        },
      ];

      const items2: Item[] = [
        {
          quantity: 10,
          nft: 'CARD',
          variation: 1,
        },
        {
          quantity: 10,
          nft: 'CARD',
          variation: 4,
        },
      ];

      await expect(nftSale.validateItems(items1)).to.not.be.reverted;
      await expect(nftSale.getTotalPriceFromItems(items2)).to.not.be.reverted;
    });

    it('Should revert', async () => {
      const [deployer] = await ethers.getSigners();

      const items1: Item[] = [
        {
          quantity: 0,
          nft: 'CARD',
          variation: 2,
        },
      ];

      const items2: Item[] = [
        {
          quantity: 10,
          nft: 'WRONG_NFT',
          variation: 1,
        },
      ];

      const items3: Item[] = [
        {
          quantity: 10,
          nft: 'CARD',
          variation: 2,
        },
        {
          quantity: 10,
          nft: 'CARD',
          variation: 30,
        },
      ];

      const items4: Item[] = [
        {
          quantity: 10,
          nft: 'WEAPON',
          variation: 1,
        },
      ];

      const nftSaleSigner = nftSale.connect(deployer);

      const setMaxQuantityByNFTAndVariationTx =
        await nftSaleSigner.setMaxQuantityByNFTAndVariation('WEAPON', 0, 2);

      await setMaxQuantityByNFTAndVariationTx.wait();

      await expect(nftSale.validateItems(items1)).to.be.revertedWith(
        "NFTSale: item quantity can't be 0"
      );

      await expect(nftSale.validateItems(items2)).to.be.revertedWith(
        'NFTSale: not found NFT address'
      );

      await expect(nftSale.getTotalPriceFromItems(items3)).to.be.revertedWith(
        'NFTSale: price must be greater than 0'
      );

      await expect(nftSale.validateItems(items4)).to.be.revertedWith(
        `NFTSale: ${items4[0].nft} must be specified`
      );
    });
  });

  describe('validateBalance', () => {
    it('Should not revert', async () => {
      const [, buyer] = await ethers.getSigners();

      const items: Item[] = [
        {
          quantity: 10,
          nft: 'CARD',
          variation: 1,
        },
      ];

      const itemsTotalPrice = await nftSale.getTotalPriceFromItems(items);

      await expect(nftSale.validateBalance(buyer.address, itemsTotalPrice)).to
        .not.be.reverted;
    });

    it('Should revert', async () => {
      const [, , , , buyer] = await ethers.getSigners();

      const items: Item[] = [
        {
          quantity: 10,
          nft: 'CARD',
          variation: 1,
        },
      ];

      const itemsTotalPrice = await nftSale.getTotalPriceFromItems(items);

      await expect(nftSale.validateBalance(buyer.address, itemsTotalPrice)).to
        .be.reverted;
    });
  });

  describe('buyItems', () => {
    it('Should mint if the buyer has enough funds', async () => {
      // Get the signers
      const [deployer] = await ethers.getSigners();

      const nftSaleSigner = nftSale.connect(deployer);

      // Disable white list only
      const setWhitelistOnly = await nftSaleSigner.setWhitelistOnly(false);

      await setWhitelistOnly.wait();

      const items: Item[] = [
        {
          quantity: 1,
          nft: 'TOY',
          variation: 1,
        },
        {
          quantity: 10,
          nft: 'CARD',
          variation: 1,
        },
        {
          quantity: 1,
          nft: 'SKIN',
          variation: 1,
        },
        {
          quantity: 1,
          nft: 'WEAPON',
          variation: 1,
        },
      ];

      await executeBuyItemsTransaction(items);
    });

    it('Should mint if the buyer has enough funds and is whitelisted', async () => {
      // Get the signers
      const [, buyer] = await ethers.getSigners();

      // Add a new account to the whitelist
      const addBuyerToWhitelistTx = await toysLegendWhiteList.add(
        buyer.address
      );

      await addBuyerToWhitelistTx.wait();

      const items: Item[] = [
        {
          quantity: 1,
          nft: 'TOY',
          variation: 1,
        },
        {
          quantity: 10,
          nft: 'CARD',
          variation: 1,
        },
        {
          quantity: 1,
          nft: 'SKIN',
          variation: 1,
        },
        {
          quantity: 1,
          nft: 'WEAPON',
          variation: 1,
        },
      ];

      await executeBuyItemsTransaction(items);
    });

    it("Should revert if the buyer isn't whitelisted", async () => {
      const [, buyer] = await ethers.getSigners();

      // Bind signer wallet to contracts
      const busdSigner = busdTokenMock.connect(buyer);
      const nftSaleSigner = nftSale.connect(buyer);

      const items: Item[] = [
        {
          quantity: 1,
          nft: 'LAND',
          variation: 1,
        },
        {
          quantity: 1,
          nft: 'TOY',
          variation: 1,
        },
        {
          quantity: 10,
          nft: 'CARD',
          variation: 1,
        },
        {
          quantity: 1,
          nft: 'SKIN',
          variation: 1,
        },
        {
          quantity: 1,
          nft: 'WEAPON',
          variation: 1,
        },
      ];

      // Get total price of items
      const totalPrice = await nftSale.getTotalPriceFromItems(items);

      // Approve totalPrice in order to transfer the funds
      await busdSigner.increaseAllowance(nftSale.address, totalPrice);

      await expect(nftSaleSigner.buyItems(items)).to.be.revertedWith(
        'NFTSale: only whitelisted users'
      );
    });

    it("Should revert if the buyer hasn't enough funds", async () => {
      const [deployer, , , , buyer] = await ethers.getSigners();

      // Bind signer wallet to contracts
      const busdSigner = busdTokenMock.connect(buyer);
      const nftSaleSigner = nftSale.connect(buyer);
      const nftSaleDeployerSigner = nftSale.connect(deployer);

      const setWhitelistOnly = await nftSaleDeployerSigner.setWhitelistOnly(
        false
      );

      await setWhitelistOnly.wait();

      const items: Item[] = [
        {
          quantity: 1,
          nft: 'CARD',
          variation: 1,
        },
      ];

      // Get total price of items
      const totalPrice = await nftSale.getTotalPriceFromItems(items);

      // Approve totalPrice in order to transfer the funds
      await busdSigner.increaseAllowance(nftSale.address, totalPrice);

      await expect(nftSaleSigner.buyItems(items)).to.be.revertedWith(
        'NFTSale: not enough BUSD'
      );
    });
  });

  describe('buyLands', () => {
    it('Should mint if the buyer has enough funds', async () => {
      // Get the signers
      const [deployer] = await ethers.getSigners();

      const nftSaleSigner = nftSale.connect(deployer);

      // Disable white list only
      const setWhitelistOnly = await nftSaleSigner.setWhitelistOnly(false);

      await setWhitelistOnly.wait();

      const pixels: LandsToBuyFromPixel[] = [
        {
          y: -5,
          x: 5,
          positions: [1],
        },
      ];

      await executeBuyLandsTransaction(pixels);
    });

    it('Should mint if the buyer has enough funds and is whitelisted', async () => {
      // Get the signers
      const [, buyer] = await ethers.getSigners();

      // Add a new account to the whitelist
      const addBuyerToWhitelistTx = await toysLegendWhiteList.add(
        buyer.address
      );

      await addBuyerToWhitelistTx.wait();

      const pixels: LandsToBuyFromPixel[] = [
        {
          y: -5,
          x: 5,
          positions: [1],
        },
      ];

      await executeBuyLandsTransaction(pixels);
    });

    it("Should revert if the buyer isn't whitelisted", async () => {
      const [, buyer] = await ethers.getSigners();

      // Bind signer wallet to contracts
      const busdSigner = busdTokenMock.connect(buyer);
      const nftSaleSigner = nftSale.connect(buyer);

      const pixels: LandsToBuyFromPixel[] = [
        {
          y: -5,
          x: 5,
          positions: [1],
        },
      ];

      // Get total price of items
      const totalPrice = await nftSale.getTotalPriceFromLands(pixels);

      // Approve totalPrice in order to transfer the funds
      await busdSigner.approve(nftSale.address, totalPrice);

      await expect(nftSaleSigner.buyLands(pixels)).to.be.revertedWith(
        'NFTSale: only whitelisted users'
      );
    });

    it("Should revert if the buyer hasn't enough funds", async () => {
      const [deployer, , , , buyer] = await ethers.getSigners();

      // Bind signer wallet to contracts
      const busdSigner = busdTokenMock.connect(buyer);
      const nftSaleSigner = nftSale.connect(buyer);
      const nftSaleDeployerSigner = nftSale.connect(deployer);

      const setWhitelistOnly = await nftSaleDeployerSigner.setWhitelistOnly(
        false
      );

      await setWhitelistOnly.wait();

      const pixels: LandsToBuyFromPixel[] = [
        {
          y: -5,
          x: 5,
          positions: [1],
        },
      ];

      // Get total price of items
      const totalPrice = await nftSale.getTotalPriceFromLands(pixels);

      // Approve totalPrice in order to transfer the funds
      await busdSigner.approve(nftSale.address, totalPrice);

      await expect(nftSaleSigner.buyLands(pixels)).to.be.revertedWith(
        'NFTSale: not enough BUSD'
      );
    });

    // it('Should revert', async () => {
    //   const [deployer, buyer, ,] = await ethers.getSigners();

    //   // Bind signer wallet to contracts
    //   const busdSigner = busdTokenMock.connect(buyer);
    //   const nftSaleSigner = nftSale.connect(buyer);
    //   const nftSaleDeployerSigner = nftSale.connect(deployer);

    //   const setWhitelistOnly = await nftSaleDeployerSigner.setWhitelistOnly(
    //     false
    //   );

    //   await setWhitelistOnly.wait();

    //   const pixels1: LandsToBuyFromPixel[] = [
    //     {
    //       y: -5,
    //       x: 5,
    //       positions: [1, 2, 3],
    //     },
    //   ];

    //   const pixels2: LandsToBuyFromPixel[] = [
    //     {
    //       y: -5,
    //       x: 5,
    //       positions: [4, 5],
    //     },
    //   ];

    //   // Get total price of items
    //   const totalPrice = await nftSale.getTotalPriceFromLands(pixels1);

    //   // Approve totalPrice in order to transfer the funds
    //   await busdSigner.approve(nftSale.address, totalPrice.mul(2));

    //   await nftSaleSigner.buyLands(pixels1);

    //   await expect(nftSaleSigner.buyLands(pixels2)).to.be.reverted;
    // });
  });
});
