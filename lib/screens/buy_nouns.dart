import 'package:flutter/material.dart';
import 'package:goals_ethglobal/providers/user_info_provider.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:erc20/erc20.dart';
import 'package:goals_ethglobal/abi/router.dart';

class BuyNouns extends StatefulWidget {
  const BuyNouns({super.key});

  @override
  State<BuyNouns> createState() => _BuyNounsState();
}

class _BuyNounsState extends State<BuyNouns> {
  // final String rpcurl = 'https://sepolia.drpc.org';

  // Future<BigInt> getAmountsOut(
  //     {String rpc =
  //         'https://api.bitstack.com/v1/wNFxbiJyQsSeLrX8RRCHi7NpRxrlErZk/DjShIqLishPCTB9HiMkPHXjUM9CNM9Na/ETH/mainnet',
  //     String router = '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D',
  //     String token = '0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984',
  //     String tokenOut = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2',
  //     num val = 1}) async {
  //   final httpClient = Client();
  //   final ethClient = Web3Client(rpc, httpClient);
  //   final contract = DeployedContract(
  //       ContractAbi.fromJson(abiR, 'Router'),
  //       EthereumAddress.fromHex(router));
  //   final result = await ethClient.call(
  //       contract: contract,
  //       function: contract.function('getAmountsOut'),
  //       params: [
  //         (BigInt.from(val) * BigInt.from(10).pow(18)),
  //         [EthereumAddress.fromHex(token), EthereumAddress.fromHex(tokenOut)]
  //       ]);
  //   if (result.isNotEmpty && result[0].length > 1) {
  //     final etherValueBigInt = result[0][1];
  //     print('The price in bigint is: $etherValueBigInt');
  //     return etherValueBigInt;
  //   } 
  //   else {
  //     throw Exception('Error: insufficient data to calculate the price');
  //   }
  // }

  // final swapExactETHForTokens = await Uniswap().swapExactETHForTokens();

  @override
  Widget build(BuildContext context) {  
    final String privatekey =  context.watch<UserProvider>().userInfos[0]['privKey'];
    final String privatekey2 = context.watch<UserProvider>().userInfos[0]['ed25519PrivKey'];
    //aqui eu crio a funcao que vai ser triggada pelo botao

    return const Placeholder();
  }
}