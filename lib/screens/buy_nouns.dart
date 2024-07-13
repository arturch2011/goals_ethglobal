import 'package:flutter/material.dart';
import 'package:goals_ethglobal/providers/user_info_provider.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';


class BuyNouns extends StatefulWidget {
  const BuyNouns({super.key});


  @override
  State<BuyNouns> createState() => _BuyNounsState();
}



class _BuyNounsState extends State<BuyNouns> {
  final String rpcurl = 'https://sepolia.drpc.org';

  @override
  Widget build(BuildContext context) {  
    final String privatekey =  context.watch<UserProvider>().userInfos[0]['privKey'];
    final String privatekey2 = context.watch<UserProvider>().userInfos[0]['ed25519PrivKey'];
    //aqui eu crio a funcao que vai ser triggada pelo botao
    
    return const Placeholder();
  }
}