import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import { ethers } from "hardhat";


describe("Goals", function () {

  describe("GoalsToken", function () {
    async function deployFixture() {
      const [owner, otherAccount] = await ethers.getSigners();
      const GoalsToken = await ethers.getContractFactory("GoalsToken");
      const goalsToken = await GoalsToken.deploy();
      return { goalsToken, owner, otherAccount };
    }
    
    it("Should deploy the GoalsToken", async function () {
      const { goalsToken } = await loadFixture(deployFixture);
      expect(await goalsToken.name()).to.equal("GoalsToken");
    });

    it("Should set the right owner", async function () {
      const { goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
      expect(await goalsToken.owner()).to.equal(owner.address);
    });

    it("Should mint 1000 tokens to the owner", async function () {
      const { goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
      await goalsToken.mint(owner.address, 1000);
      expect(await goalsToken.balanceOf(owner.address)).to.equal(1000);
    });

    it("Should mint 1000 tokens to the otherAccount", async function () {
      const { goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
      await goalsToken.mint(otherAccount.address, 1000);
      expect(await goalsToken.balanceOf(otherAccount.address)).to.equal(1000);
    });

    it("Should transfer 100 tokens from owner to otherAccount", async function () {
      const { goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
      await goalsToken.mint(owner.address, 1000);
      await goalsToken.transfer(otherAccount.address, 100);
      expect(await goalsToken.balanceOf(owner.address)).to.equal(900);
      expect(await goalsToken.balanceOf(otherAccount.address)).to.equal(100);
    });

    it("Should burn 100 tokens from owner", async function () {
      const { goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
      await goalsToken.mint(owner.address, 1000);
      await goalsToken.burn(100);
      expect(await goalsToken.balanceOf(owner.address)).to.equal(900);
    });

  });

  describe("GoalsContract", function () {
    async function deployFixture() {
      const [owner, otherAccount] = await ethers.getSigners();
      const GoalsToken = await ethers.getContractFactory("GoalsToken");
      const goalsToken = await GoalsToken.deploy();
      const addr = await goalsToken.getAddress();
      const Goals = await ethers.getContractFactory("Goals");
      const goals = await Goals.deploy(addr);
      return { goals, goalsToken, owner, otherAccount };
    }

    it("Should deploy the GoalsContract", async function () {
      const { goals, goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
      expect(await goals.getAddress()).not.to.be.undefined;
    });

    it("Should set the right owner", async function () {
      const { goals, goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
      expect(await goals.owner()).to.equal(owner.address);
    });

    it("Should set the right token", async function () {
      const { goals, goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
      const addr = await goals.token();
      expect(addr).to.equal(await goalsToken.getAddress());
    });

    it("Should create a goal", async function () {
      const { goals, goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
      await goalsToken.mint(owner.address, 1000);
      await goalsToken.approve(goals.getAddress(), 1000);
      await goals.createGoal("Test Name", "Test Description", "Test Category", "Teste Frequency Type", 100, 1000, 10000, 100000, true, 100, 10000000, ["blablabla"], "km", 10, 1000);
      const goal = await goals.getGoal();
      expect(goal[0].name).to.equal("Test Name");
    });

    it("Should not create a goal if the user has less tokens than pre-funded", async function () {
      const { goals, goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
      await expect(goals.createGoal(
        "Test Name", 
        "Test Description", 
        "Test Category", 
        "Teste Frequency Type", 
        2, 
        10, 
        10000, 
        100000, 
        true, 
        100, 
        10000000, 
        ["blablabla"], 
        "km", 
        10, 
        1000
      )).to.be.revertedWith("Insufficient funds");
      
    });

    describe("Interaction with a Goal", function () {
      async function deployFixture() {
        const [owner, otherAccount, thirdAccount] = await ethers.getSigners();
        const GoalsToken = await ethers.getContractFactory("GoalsToken");
        const goalsToken = await GoalsToken.deploy();
        const addr = await goalsToken.getAddress();
        const Goals = await ethers.getContractFactory("Goals");
        const goals = await Goals.deploy(addr);

        await goalsToken.mint(owner.address, 1000000000);
        await goalsToken.approve(await goals.getAddress(), 1000000000);
        await goalsToken.mint(otherAccount.address, 100000000);
        await goalsToken.connect(otherAccount).approve(await goals.getAddress(), 10000000);
        await goalsToken.mint(thirdAccount.address, 100000000);
        await goalsToken.connect(thirdAccount).approve(await goals.getAddress(), 10000000);
        goalsToken.connect(owner);
        await goals.createGoal("Test Name", "Test Description", "Test Category", "Teste Frequency Type", 2, 10, 1000, 100000, true, 100, 10000000, ["blablabla"], "km", 10, 1000);

        return { goals, goalsToken, owner, otherAccount, thirdAccount };
      }

      it("Should let otherAccount participate in the goal", async function () {
        const { goals, goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
        await goals.connect(otherAccount).enterGoal(0, 10000);
        const enteredGoals = await goals.connect(otherAccount).getMyEnteredGoals();
        const myBets = await goals.connect(otherAccount).getMyBets(0);
        expect(enteredGoals[0]).to.equal(0);
        expect(myBets).to.equal(10000);
      });

      it("Should not let creator start the goal with 0 participants", async function () {
        const { goals, goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
        await expect(goals.startGoal(0)).to.be.revertedWith("No participants in this goal");
      });

      it("Should let creator start and finish the goal with no winnig participant", async function () {
        const { goals, goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
        await goals.connect(otherAccount).enterGoal(0, 10000);
        await goals.connect(owner).startGoal(0);
        await goals.completeGoal(0);
        const goal = await goals.getGoal();
        expect(goal[0].isCompleted).to.equal(true);
      });

      it("Should let user to update it's progress", async function () {
        const { goals, goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
        await goals.connect(otherAccount).enterGoal(0, 10000);
        await goals.startGoal(0);
        await goals.connect(otherAccount).updateFrequency(0, "Imagem teste");
        const myUris = await goals.getParticipantsUri(0, otherAccount.address);
        expect(myUris[0]).to.equal("Imagem teste");
      });

      it("Should complete the goal with a premiated participant", async function () {
        const { goals, goalsToken, owner, otherAccount } = await loadFixture(deployFixture);
        const initBalance = await goalsToken.balanceOf(otherAccount.address);
        
        await goals.connect(otherAccount).enterGoal(0, 10000);
        
        const inGoalBalance = await goalsToken.balanceOf(otherAccount.address);
        
        await goals.connect(owner).startGoal(0);
        await goals.connect(otherAccount).updateFrequency(0, "Imagem teste");
        await goals.connect(otherAccount).updateFrequency(0, "Imagem teste 2");
        await goals.connect(owner).autenticateFrequency(0, otherAccount.address, 2, [0, 1])
        await goals.connect(owner).completeGoal(0);
        
        const finalBalance = await goalsToken.balanceOf(otherAccount.address);
        const goal = await goals.getGoal();
        
        expect(goal[0].isCompleted).to.equal(true);
        expect(finalBalance).to.be.greaterThan(initBalance);
        expect(initBalance).to.be.greaterThan(inGoalBalance);
      });

      it("Should distribute the right amount of tokens to the premiated participant", async function () {
        const { goals, goalsToken, owner, otherAccount, thirdAccount } = await loadFixture(deployFixture);
        const initBalance = await goalsToken.balanceOf(otherAccount.address);
        const initBalanceThird = await goalsToken.balanceOf(thirdAccount.address);
        const ownerInitBalance = await goalsToken.balanceOf(owner.address);
        
        await goals.connect(otherAccount).enterGoal(0, 10000);
        await goals.connect(thirdAccount).enterGoal(0, 10000);
        
        const inGoalBalance = await goalsToken.balanceOf(otherAccount.address);
        const inGoalBalanceThird = await goalsToken.balanceOf(thirdAccount.address);
        
        await goals.connect(owner).startGoal(0);
        await goals.connect(otherAccount).updateFrequency(0, "Imagem teste");
        await goals.connect(otherAccount).updateFrequency(0, "Imagem teste 2");
        await goals.connect(owner).autenticateFrequency(0, otherAccount.address, 2, [0, 1])
        await goals.connect(owner).completeGoal(0);
        
        const finalBalance = await goalsToken.balanceOf(otherAccount.address);
        const finalBalanceThird = await goalsToken.balanceOf(thirdAccount.address);

        const prefund = await goals.getGoal();
        const pre = prefund[0].preFund;
        const prize = (((initBalanceThird - inGoalBalanceThird + pre)/ BigInt(2)));

        const ownerFinalBalance = await goalsToken.balanceOf(owner.address);
        
        expect(finalBalanceThird).to.be.equal(inGoalBalanceThird);
        expect(finalBalance).to.be.equal(initBalance + prize);
        expect(ownerFinalBalance).to.be.equal(ownerInitBalance + prize);


      });
      
    });

  });

});