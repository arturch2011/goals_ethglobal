import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { ethers } from "ethers";

const walletAddr = "0x99Fa57D8192814b50Db31717960B07167d6Ee515"

const onlyGoalsToken = buildModule("onlyGoalsToken",  (m) => {
    const token = m.contract("GoalsToken", []);
    const amountInWei = ethers.parseEther("1000000");
    m.call(token, "mint", [walletAddr, amountInWei]);

    return { token };
});

export default onlyGoalsToken;