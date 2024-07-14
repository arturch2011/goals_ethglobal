import { createPublicClient, hexToBigInt, http, parseEther, formatEther } from "viem";
import { celoAlfajores } from "viem/chains";

// USDC is 6 decimals and hence requires the adapter address instead of the token address
const USDC_ADAPTER_MAINNET = "0x2F25deB3848C207fc8E0c34035B3Ba7fC157602B";
const USDC_ADAPTER_TESTNET = "0x4822e58de6f5e485eF90df51C41CE01721331dC0";

const publicClient = createPublicClient({
  chain: celoAlfajores,
  transport: http(),
});

const transaction = {
  from: "0xba069fDDDd4f8F2bc7b18bC433b8FEcEEAfEfEb2",
  to: "0x4822e58de6f5e485eF90df51C41CE01721331dC0",
  value: parseEther('1'),
  feeCurrency: USDC_ADAPTER_TESTNET,
  
};

async function getGasPriceInUSDC() {
  const priceHex = await publicClient.request({
    method: "eth_gasPrice",
    params: [USDC_ADAPTER_TESTNET],
  });

  return hexToBigInt(priceHex);
}

async function estimateGasPriceInUSDC(transaction) {
  const estimatedGasInHex = await publicClient.estimateGas(publicClient, {
    ...transaction,

    // just in case the transaction itself does not have feeCurrency property in it.
    feeCurrency: USDC_ADAPTER_TESTNET,
  });

  return hexToBigInt(estimatedGasInHex);
}

async function main() {
  const gasPriceInUSDC = await getGasPriceInUSDC();

  const estimatedGasPrice = await estimateGasPriceInUSDC(transaction);

  /* 
    Transaction fee in USDC to perform the above transaction.
    This amount should not be transferrable in case the user tries to transfer the entire amount.
  */
  const transactionFeeInUSDC = formatEther(
    gasPriceInUSDC * estimatedGasPrice,
  ).toString();

  console.log(transactionFeeInUSDC)
  return transactionFeeInUSDC;
}

await main();