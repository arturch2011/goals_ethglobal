// ignore_for_file: prefer_const_declarations, non_constant_identifier_names, avoid_print, prefer_const_constructors

import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:erc20/erc20.dart';
import 'package:goals_ethglobal/abi/router.dart';

class Uniswap {
  Future<BigInt> getAmountsOut(
      {String rpc =
          'https://api.bitstack.com/v1/wNFxbiJyQsSeLrX8RRCHi7NpRxrlErZk/DjShIqLishPCTB9HiMkPHXjUM9CNM9Na/ETH/mainnet',
      String router = '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D',
      String token = '0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984',
      String tokenOut = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2',
      num val = 1}) async {
    final httpClient = Client();
    final ethClient = Web3Client(rpc, httpClient);
    final contract = DeployedContract(
        ContractAbi.fromJson(abiR, 'Router'), EthereumAddress.fromHex(router));
    final result = await ethClient.call(
        contract: contract,
        function: contract.function('getAmountsOut'),
        params: [
          (BigInt.from(val) * BigInt.from(10).pow(18)),
          [EthereumAddress.fromHex(token), EthereumAddress.fromHex(tokenOut)]
        ]);
    if (result.isNotEmpty && result[0].length > 1) {
      final etherValueBigInt = result[0][1];
      print('The price in bigint is: $etherValueBigInt');
      return etherValueBigInt;
    } else {
      throw Exception('Error: insufficient data to calculate the price');
    }
  }

  BigInt convertToBigInt(num value) {
    if (value is int) {
      return BigInt.from(value) * BigInt.from(10).pow(18);
    } else if (value is double) {
      BigInt pres = BigInt.from(10).pow(18);
      return BigInt.from((value * pres.toInt()));
    } else {
      throw ArgumentError('Value must be an int or a double');
    }
  }

//Future<String> swapETHForExactTokens() async {}

  Future<String> swapExactETHForTokens(String credentials, num tokenAmount,
      String tokenOut, String recipient, int timestamp) async {
    try {
      final String rpc =
          'https://api.bitstack.com/v1/wNFxbiJyQsSeLrX8RRCHi7NpRxrlErZk/DjShIqLishPCTB9HiMkPHXjUM9CNM9Na/ETH/mainnet';
      final String eth = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2';
      final amountOutMin = convertToBigInt(tokenAmount);
      final List path = [
        EthereumAddress.fromHex(eth),
        EthereumAddress.fromHex(tokenOut)
      ];
      final EthereumAddress to = EthereumAddress.fromHex(recipient);
      final BigInt deadline = BigInt.from(timestamp);
      final Web3Client provider = Web3Client(rpc, Client());
      final EthereumAddress routerAddress =
          EthereumAddress.fromHex('0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D');
      final ContractAbi routerAbi = ContractAbi.fromJson(abi, 'Router');
      final DeployedContract routerContract =
          DeployedContract(routerAbi, routerAddress);
      final function = routerContract.function('swapExactETHForTokens');
      final BigInt payableAmount =
          await getAmountsOut(token: tokenOut, val: tokenAmount);
      print('Running: swapExactETHForTokens');
      final result = await provider.sendTransaction(
        EthPrivateKey.fromHex(credentials),
        Transaction.callContract(
          contract: routerContract,
          function: function,
          parameters: [
            amountOutMin,
            path,
            to,
            deadline,
          ],
          value: EtherAmount.inWei(payableAmount),
        ),
        chainId: 1,
      );
      print('Success: swapExactETHForTokens');
      return result;
    } catch (err) {
      print(err);
      throw Exception(err);
    }
  }

/*Future<String> swapExactTokensForETH() async {}

Future<String> swapTokensForExactTokens(String credentials, num ethAmount,
    num amountOutput, String tokenOut, String recipient, int timestamp) async {
  try {
    final BigInt payableAmount = BigInt.from(ethAmount).pow(18);
    final String eth = '0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6';
    final List path = [
      EthereumAddress.fromHex(eth),
      EthereumAddress.fromHex(tokenOut)
    ];
    final EthereumAddress to = EthereumAddress.fromHex(recipient);
    final BigInt deadline = BigInt.from(timestamp);
    final String rpc =
        'https://goerli.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161';
    final Web3Client provider = Web3Client(rpc, Client());
    final EthereumAddress routerAddress =
        EthereumAddress.fromHex('0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D');
    final ContractAbi routerAbi = ContractAbi.fromJson(abi, 'Router');
    final DeployedContract routerContract =
        DeployedContract(routerAbi, routerAddress);
    final function = routerContract.function('swapExactETHForTokens');
    final token = ERC20(
      address: EthereumAddress.fromHex(eth),
      client: provider,
    );
    print('Approving...');
    await token.approve(
        credentials: EthPrivateKey.fromHex(credentials),
        routerAddress,
        amountOutMin);
    print('Approved');
    final amountOutMin = await ShitCoinPrice().asBigInt();
    print('Running: swapExactETHForTokens');
    final result = await provider.sendTransaction(
      EthPrivateKey.fromHex(credentials),
      Transaction.callContract(
        contract: routerContract,
        function: function,
        parameters: [
          amountOutMin,
          path,
          to,
          deadline,
        ],
        value: EtherAmount.inWei(payableAmount),
      ),
      chainId: 5,
    );
    print('Success: swapExactETHForTokens');
    return result;
  } catch (err) {
    print(err);
    throw Exception(err);
  }
}*/

  Future<String> swapExactTokensForTokens(
      String credentials,
      num amountInput,
      num amountOutput,
      String tokenIn,
      String tokenOut,
      String recipient,
      int timestamp) async {
    final amountIn = BigInt.from(amountInput).pow(18);
    final amountOutMin = BigInt.from(amountOutput).pow(18);
    final path = [
      EthereumAddress.fromHex(tokenIn),
      EthereumAddress.fromHex(tokenOut)
    ];
    final to = EthereumAddress.fromHex(recipient);
    final deadline = BigInt.from(timestamp);
    final rpc = 'https://bsc-dataseed.binance.org/';
    final provider = Web3Client(rpc, Client());
    final routerAddress =
        EthereumAddress.fromHex('0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D');
    final routerAbi = ContractAbi.fromJson(abi, 'Router');
    final routerContract = DeployedContract(routerAbi, routerAddress);
    final function = routerContract.function('swapExactTokensForTokens');
    final result = await provider.sendTransaction(
      EthPrivateKey.fromHex(credentials),
      Transaction.callContract(
        contract: routerContract,
        function: function,
        parameters: [
          amountIn,
          amountOutMin,
          path,
          to,
          deadline,
        ],
        // value: EtherAmount.inWei(value),
      ),
    );
    return result;
  }

/*Future<String> swapTokensForExactETH() async {}

Future<String> swapExactETHForTokensSupportingFeeOnTransferTokens() async {}

Future<String> swapExactTokensForETHSupportingFeeOnTransferTokens() async {}

Future<String> swapExactTokensForTokensSupportingFeeOnTransferTokens() async {}*/
}