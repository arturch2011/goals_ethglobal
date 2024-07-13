import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const goalsTokenAddr = "0x6339240e1E2e1a1a8b6fD7f5200859668346e999";

const onlyGoals = buildModule("onlyGoals",  (m) => {
    const goal = m.contract("Goals", [goalsTokenAddr]);

    return { goal };
});

export default onlyGoals;