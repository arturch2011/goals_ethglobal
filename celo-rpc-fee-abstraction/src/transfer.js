import { createPublicClient, hexToBigInt, createWalletClient, http, parseEther, encodeFunctionData } from "viem";
import { celoAlfajores } from "viem/chains";
import { privateKeyToAccount } from "viem/accounts";
import { stableTokenABI } from "@celo/abis";

// Creating account from private key, you can choose to do it any other way.
const account = privateKeyToAccount("0x288ac9276acd54e2ea3d159291475b08ff89772894041bb2abd0036ef5386e1a");

const publicClient = createPublicClient({
    chain: celoAlfajores,
    transport: http(),
});

// WalletClient can perform transactions.
const client = createWalletClient({
  account,

  // Passing chain is how viem knows to try serializing tx as cip42.
  chain: celoAlfajores,
  transport: http(),
});

// const USDC_ADAPTER_MAINNET = "0x2F25deB3848C207fc8E0c34035B3Ba7fC157602B";
// const USDC_MAINNET = "0xcebA9300f2b948710d2653dD7B07f33A8B32118C";
const USDC_TESTNET="0x2F25deB3848C207fc8E0c34035B3Ba7fC157602B"
const USDC_ADAPTER_TESTNET = "0x4822e58de6f5e485eF90df51C41CE01721331dC0";

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

/*
  The UI of the wallet should calculate the transaction fees, show it and consider the amount to not be part of the asset that the user i.e the amount corresponding to transaction fees should not be transferrable.
*/
async function calculateTransactionFeesInUSDC(transaction) {
  // Implementation of getGasPriceInUSDC is in the above code snippet
  const gasPriceInUSDC = await getGasPriceInUSDC();

  // Implementation of estimateGasInUSDC is in the above code snippet
  const estimatedGasPrice = await estimateGasPriceInUSDC(transaction);

  return gasPriceInUSDC * estimatedGasPrice;
}

async function send(amountInWei) {
  const to = USDC_TESTNET;

  // Data to perform an ERC20 transfer
  const data = encodeFunctionData({
    abi: stableTokenABI,
    functionName: "transfer",
    args: [
      "0xccc9576F841de93Cd32bEe7B98fE8B9BD3070e3D",
      // Different tokens can have different decimals, cUSD (18), USDC (6)
      amountInWei,
    ],
  });

  const transactionFee = await calculateTransactionFeesInUSDC({ to, data });

  const tokenReceivedbyReceiver = parseEther("0.1") - transactionFee;

  /* 
    Now the data has to be encode again but with different transfer value because the receiver receives the amount minus the transaction fee.
  */
  const dataAfterFeeCalculation = encodeFunctionData({
    abi: stableTokenABI,
    functionName: "transfer",
    args: [
      "0xccc9576F841de93Cd32bEe7B98fE8B9BD3070e3D",
      // Different tokens can have different decimals, cUSD (18), USDC (6)
      tokenReceivedbyReceiver,
    ],
  });

  // Transaction hash
  const hash = await client.sendTransaction({
    ...{ to, data: dataAfterFeeCalculation },

    /*
      In case the transaction request does not include the feeCurrency property, the wallet can add it or change it to a different currency based on the user balance.

      Notice that we use the USDC_ADAPTER_MAINNET address not the token address this is because at the protocol level only 18 decimals tokens are supported, but USDC is 6 decimals, the adapter acts a unit converter.
    */
    feeCurrency: USDC_ADAPTER_TESTNET,
  });

  return hash;
}

await send(1000000000000000000);