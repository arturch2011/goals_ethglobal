import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const walletAddr = "0xC4b9190C160253071375c4d3e4f2574E8Bb57FD5"

const onlyGoalsToken = buildModule("onlyGoalsToken",  (m) => {
    const token = m.contract("GoalsToken", []);
    m.call(token, "mint", [walletAddr, 10000000000000000000000000])

    return { token };
});

export default onlyGoalsToken;