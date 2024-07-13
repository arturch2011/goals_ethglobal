import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const goalsTokenAddr = "0x905a3dB053b868e9ECb0D368f43b1C825d9e485f";
const sepoliaNFTBackedAddr = "0x34182d56d905a195524a8F1813180C134687ca34";

const onlyGoals = buildModule("onlyGoals",  (m) => {
    const goal = m.contract("Goals", [goalsTokenAddr, sepoliaNFTBackedAddr]);

    return { goal };
});

export default onlyGoals;