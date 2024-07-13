import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const goalsTokenAddr = "0x905a3dB053b868e9ECb0D368f43b1C825d9e485f";

const onlyGoals = buildModule("onlyGoals",  (m) => {
    const goal = m.contract("Goals", [goalsTokenAddr]);

    return { goal };
});

export default onlyGoals;