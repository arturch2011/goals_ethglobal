import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

// import 'package:provider/provider.dart';
// import 'package:goals_flutter/providers/user_info_provider.dart';

late String privKey;

getPrivKey(key) {
  privKey = key;
  return privKey;
}

var getPrivKeys = getPrivKey;

final ethUtilsProviders = StateNotifierProvider<EthereumUtils, bool>((ref) {
  return EthereumUtils();
});

class EthereumUtils extends StateNotifier<bool> {
  EthereumUtils() : super(true) {
    initialSetup();
  }

  // String address = UserProvider().userInfos[0]['privKey'];
  Web3Client? _ethClient;
  bool isLoading = true;
  String? _abi;
  String? _abiToken;
  EthereumAddress? _contractAddress;
  EthereumAddress? _contractAddressToken;
  Credentials? _credentials;
  DeployedContract? _contract;
  DeployedContract? _contractToken;
  EthereumAddress? address;

  // ContractFunction? _userName;
  // ContractFunction? _setName;

  ContractFunction? _createGoal;
  ContractFunction? _startGoal;
  ContractFunction? _enterGoal;
  ContractFunction? _updateFrequency;
  ContractFunction? _autenticateFrequency;
  ContractFunction? _completeGoal;
  ContractFunction? _getGoal;
  ContractFunction? _getMyProgress;
  ContractFunction? _getMyBets;
  ContractFunction? _participants;
  ContractFunction? _bets;
  ContractFunction? _myGoals;
  ContractFunction? _myEnteredGoals;
  ContractFunction? _getParticipantsUri;

  ContractFunction? _approve;
  ContractFunction? _burn;
  ContractFunction? _burnFrom;
  ContractFunction? _mint;
  ContractFunction? _pause;
  ContractFunction? _permit;
  ContractFunction? _renounceOwnership;
  ContractFunction? _transfer;
  ContractFunction? _transferFrom;
  ContractFunction? _transferOwnership;
  ContractFunction? _unpause;
  ContractFunction? _allowance;
  ContractFunction? _balanceOf;
  ContractFunction? _decimals;
  ContractFunction? _DOMAIN_SEPARATOR;
  ContractFunction? _eip712Domain;
  ContractFunction? _name;
  ContractFunction? _nonces;
  ContractFunction? _owner;
  ContractFunction? _paused;
  ContractFunction? _symbol;
  ContractFunction? _totalSupply;

  List<dynamic> goals = [];
  List<dynamic> myEnteredGoals = [];
  List<dynamic> myCreatedGoals = [];
  String publicAddr = '';

  final String addr = dotenv.env['CONTRACT_ADDRESS']!;
  final String addrToken = dotenv.env['CONTRACT_ADDRESS_TOKEN']!;
  final String projectId = dotenv.env['NEXT_PUBLIC_PROJECT_ID']!;

  final String _rpcUrl =
      'https://polygon-mainnet.infura.io/v3/1bac17a54bf944d591a6be48d3c7514c';

  initialSetup() async {
    http.Client httpClient = http.Client();
    _ethClient = Web3Client(_rpcUrl, httpClient);

    await getAbi();
    await getCredential();
    await getDeployedContract();
    await getGoals();
    await getMyEnteredGoals();
    await getMyGoals();
  }

  Future<void> getAbi() async {
    String abiStringFile =
        await rootBundle.loadString("build/contracts/Goals.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abi = jsonEncode(jsonAbi['abi']);

    String abiStringFileToken =
        await rootBundle.loadString("build/contracts/GoalsToken.json");
    var jsonAbiToken = jsonDecode(abiStringFileToken);
    _abiToken = jsonEncode(jsonAbiToken['abi']);

    _contractAddress = EthereumAddress.fromHex(addr);
    _contractAddressToken = EthereumAddress.fromHex(addrToken);
  }

  Future<void> getCredential() async {
    _credentials = EthPrivateKey.fromHex(privKey);
    print("Private keyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
    print(privKey);
    publicAddr = _credentials!.address.toString();
    address = _credentials!.address;
  }

  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abi!, "Goals"), _contractAddress!);

    _contractToken = DeployedContract(
        ContractAbi.fromJson(_abiToken!, "GoalsToken"), _contractAddressToken!);

    // _userName = _contract!.function("userName");
    // _setName = _contract!.function("setName");

    _createGoal = _contract!.function("createGoal");
    _startGoal = _contract!.function("startGoal");
    _enterGoal = _contract!.function("enterGoal");
    _updateFrequency = _contract!.function("updateFrequency");
    _autenticateFrequency = _contract!.function("autenticateFrequency");
    _completeGoal = _contract!.function("completeGoal");
    _getGoal = _contract!.function("getGoal");
    _getMyProgress = _contract!.function("getMyProgress");
    _getMyBets = _contract!.function("getMyBets");
    _participants = _contract!.function("participants");
    _bets = _contract!.function("bets");
    _myGoals = _contract!.function("getMyGoals");
    _myEnteredGoals = _contract!.function("getMyEnteredGoals");
    _getParticipantsUri = _contract!.function("getParticipantsUri");

    _approve = _contractToken!.function("approve");
    _burn = _contractToken!.function("burn");
    _burnFrom = _contractToken!.function("burnFrom");
    _mint = _contractToken!.function("mint");
    _pause = _contractToken!.function("pause");
    _permit = _contractToken!.function("permit");
    _renounceOwnership = _contractToken!.function("renounceOwnership");
    _transfer = _contractToken!.function("transfer");
    _transferFrom = _contractToken!.function("transferFrom");
    _transferOwnership = _contractToken!.function("transferOwnership");
    _unpause = _contractToken!.function("unpause");
    _allowance = _contractToken!.function("allowance");
    _balanceOf = _contractToken!.function("balanceOf");
    _decimals = _contractToken!.function("decimals");
    _DOMAIN_SEPARATOR = _contractToken!.function("DOMAIN_SEPARATOR");
    _eip712Domain = _contractToken!.function("eip712Domain");
    _name = _contractToken!.function("name");
    _nonces = _contractToken!.function("nonces");
    _owner = _contractToken!.function("owner");
    _paused = _contractToken!.function("paused");
    _symbol = _contractToken!.function("symbol");
    _totalSupply = _contractToken!.function("totalSupply");

    getGoals();
  }

  getGoals() async {
    try {
      goals = await _ethClient!.call(
          contract: _contract!,
          function: _getGoal!,
          params: [],
          sender: _credentials!.address);
      // goals.add(currentGoals);
    } catch (e) {
      print(e);
    }
    // var currentGoals = await _ethClient!.call(
    //     contract: _contract!,
    //     function: _getGoal!,
    //     params: [zeroBigInt],
    //     sender: _credentials!.address);
    print(_credentials!);

    isLoading = false;
    state = isLoading;
    return goals;
  }

  createGoal(
    String name,
    String description,
    String category,
    String frequency,
    BigInt target,
    double minimumbet,
    BigInt startDate,
    BigInt endDate,
    bool isPublic,
    double preFund,
    BigInt maxParticipants,
    List<String> uris,
    String typeTarqueFreq,
    BigInt quantity,
    BigInt numFreq,
  ) async {
    isLoading = true;
    state = isLoading;
    BigInt bigPreFund = BigInt.from(preFund * 10e17);
    if (bigPreFund > BigInt.zero) {
      await approve(_contractAddress!, bigPreFund);
    }

    String tran = await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _createGoal!,
        parameters: [
          name,
          description,
          category,
          frequency,
          target,
          BigInt.from(minimumbet * 10e17),
          startDate,
          endDate,
          isPublic,
          bigPreFund,
          maxParticipants,
          uris,
          typeTarqueFreq,
          quantity,
          numFreq,
        ],
        from: _credentials!.address,
      ),
      chainId: 137,
    );

    print("Transaction hash: $tran");
    getGoals();
  }

  startGoal(BigInt goalId) async {
    // isLoading = true;
    // state = isLoading;
    String tran = await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _startGoal!,
        parameters: [goalId],
        from: _credentials!.address,
      ),
      chainId: 137,
    );
    print(tran);

    getGoals();
  }

  enterGoal(BigInt goalId, double bet) async {
    isLoading = true;
    state = isLoading;
    BigInt bigBet = BigInt.from(bet * 10e17);
    await approve(_contractAddress!, bigBet);

    String tran = await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _enterGoal!,
        parameters: [goalId, bigBet],
        from: _credentials!.address,
      ),
      chainId: 137,
    );
    print(tran);

    getGoals();
  }

  updateFrequency(BigInt goalId, String frequency) async {
    isLoading = true;
    state = isLoading;
    String tran = await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _updateFrequency!,
        parameters: [goalId, frequency],
        from: _credentials!.address,
      ),
      chainId: 137,
    );
    print(tran);

    getGoals();
  }

  autenticateFrequency(BigInt goalId, String participant) async {
    isLoading = true;
    state = isLoading;
    String tran = await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _autenticateFrequency!,
        parameters: [goalId, participant],
        from: _credentials!.address,
      ),
      chainId: 137,
    );
    print(tran);

    getGoals();
  }

  completeGoal(BigInt goalId) async {
    // isLoading = true;
    // state = isLoading;
    String tran = await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contract!,
        function: _completeGoal!,
        parameters: [goalId],
        from: _credentials!.address,
      ),
      chainId: 137,
    );
    print(tran);

    getGoals();
  }

  getMyProgress(BigInt goalId) async {
    // isLoading = true;
    // state = isLoading;
    var progress = await _ethClient!.call(
        contract: _contract!,
        function: _getMyProgress!,
        params: [goalId],
        sender: _credentials!.address);
    print(progress);
    // isLoading = false;
    // state = isLoading;
    return progress;
  }

  getMyBets(BigInt goalId) async {
    // isLoading = true;
    // state = isLoading;
    var bets = await _ethClient!.call(
        contract: _contract!,
        function: _getMyBets!,
        params: [goalId],
        sender: _credentials!.address);
    print(bets);
    // isLoading = false;
    // state = isLoading;
    return bets;
  }

  getParticipants(BigInt goalId) async {
    isLoading = true;
    state = isLoading;
    var participants = await _ethClient!.call(
        contract: _contract!,
        function: _participants!,
        params: [goalId],
        sender: _credentials!.address);
    print(participants);
    isLoading = false;
    state = isLoading;
    return participants;
  }

  getBets(BigInt goalId) async {
    isLoading = true;
    state = isLoading;
    var bets = await _ethClient!.call(
        contract: _contract!,
        function: _bets!,
        params: [goalId],
        sender: _credentials!.address);
    print(bets);
    isLoading = false;
    state = isLoading;
    return bets;
  }

  getMyGoals() async {
    // isLoading = true;
    // state = isLoading;
    myCreatedGoals = await _ethClient!.call(
        contract: _contract!,
        function: _myGoals!,
        params: [],
        sender: _credentials!.address);
    print(myCreatedGoals);
    // isLoading = false;
    // state = isLoading;
    return myCreatedGoals;
  }

  getMyEnteredGoals() async {
    // isLoading = true;
    // state = isLoading;
    myEnteredGoals = await _ethClient!.call(
        contract: _contract!,
        function: _myEnteredGoals!,
        params: [],
        sender: _credentials!.address);
    print(myEnteredGoals);

    // isLoading = false;
    // state = isLoading;
    return myEnteredGoals;
  }

  approve(EthereumAddress spender, BigInt amount) async {
    isLoading = true;
    state = isLoading;
    print(_credentials!.address);
    try {
      var gasPrice = await _ethClient!.getGasPrice();
      String tran = await _ethClient!.sendTransaction(
        _credentials!,
        Transaction.callContract(
          contract: _contractToken!,
          function: _approve!,
          parameters: [spender, amount],
          from: _credentials!.address,
        ),
        chainId: 137,
      );

      print(tran);
      TransactionReceipt? receipt;
      while (true) {
        receipt = await _ethClient!.getTransactionReceipt(tran);
        print(receipt);
        if (receipt != null) {
          break;
        }
        await Future.delayed(const Duration(seconds: 1));
      }
      print(tran);
    } catch (e) {
      print(e);
    }
  }

  balanceOf(EthereumAddress addr) async {
    var balance = await _ethClient!.call(
        contract: _contractToken!,
        function: _balanceOf!,
        params: [addr],
        sender: _credentials!.address);
    print(balance);
    return balance;
  }

  transfer(EthereumAddress to, BigInt amount) async {
    BigInt amountInWei =
        EtherAmount.fromBigInt(EtherUnit.ether, amount).getInWei;
    String tran = await _ethClient!.sendTransaction(
      _credentials!,
      Transaction.callContract(
        contract: _contractToken!,
        function: _transfer!,
        parameters: [to, amountInWei],
        from: _credentials!.address,
      ),
      chainId: 137,
    );
    print('BBBBBBBBBBBBBBBBBBBBb');
    print(tran);
  }

  getParticipantsUri(int goalId, String addr) async {
    EthereumAddress addres = EthereumAddress.fromHex(addr);
    BigInt bigId = BigInt.from(goalId);

    var uris = await _ethClient!.call(
      contract: _contract!,
      function: _getParticipantsUri!,
      params: [bigId, addres],
    );

    return uris;
  }

  weiToEth(BigInt wei) {
    var eth = wei / BigInt.from(10).pow(18);

    return eth;
  }
}
