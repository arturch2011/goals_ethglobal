import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:goals_ethglobal/utils/eth_utils.dart';
import 'package:goals_ethglobal/utils/payment_manager.dart';
import 'package:goals_ethglobal/widgets/loading_popup.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:web3dart/web3dart.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

bool active = true;
List<String> categorias = ['Card'];
double? coins = 0.0;
double? coinsWithdraw = 0.0;
String? email = '';
String? chavePix = '';

void stripeInit() {
  String pubKey =
      "pk_live_51NnCHhDliFA16vYFSzy4phus653GHET4bJueRV1ghy4qZHYNSAe6BDE7L9SEYUcfJKbeDBc4QJIjHuDiVJwSG5MM009PpcRlVp";
  Stripe.publishableKey = pubKey;
}

class _WalletState extends State<Wallet> {
  @override
  void initState() {
    super.initState();
    stripeInit();
  }

  String categoriaSelecionada = categorias[0];

  Widget depositForm() {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(ethUtilsProviders);
        final ethUtils = ref.read(ethUtilsProviders.notifier);
        String address = ethUtils.publicAddr;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Choose the amount of credits you want to deposit:'),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) => setState(() {
                  if (value.isEmpty) {
                    coins = 0;
                  } else {
                    coins = double.parse(value);
                  }
                }),
                decoration: InputDecoration(
                  labelText: 'Tokens quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Payment method:'),
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          categoriaSelecionada = categorias[index];
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: categoriaSelecionada == categorias[index]
                              ? Colors.black
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: Center(
                            child: Text(
                          categorias[index],
                          style: TextStyle(
                            color: categoriaSelecionada == categorias[index]
                                ? Colors.white
                                : Colors.black,
                          ),
                        )),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text('Total: \$$coins'),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    showLoadingDialog(context);
                    await PaymentManager.makePayment(
                        coins!.toInt(),
                        "\$",
                        address,
                        context); // alterar para adicionar o email do usuario
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16.0), // Raio dos cantos
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).primaryColor,
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  child:
                      const Text('Buy', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget withdrawForm() {
    return Consumer(builder: (context, ref, child) {
      ref.watch(ethUtilsProviders);
      final ethUtils = ref.read(ethUtilsProviders.notifier);
      String address = ethUtils.publicAddr;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text('Choose the amount of credits you want to withdraw:'),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {
                if (value.isEmpty) {
                  coinsWithdraw = 0;
                } else {
                  coinsWithdraw = double.parse(value);
                }
              }),
              decoration: InputDecoration(
                labelText: 'Tokens quantity',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Your email:'),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (value) => setState(() {
                if (value.isEmpty) {
                  email = '';
                } else {
                  email = value;
                }
              }),
              decoration: InputDecoration(
                labelText: 'email@exemplo.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('key:'),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (value) => setState(() {
                if (value.isEmpty) {
                  chavePix = '';
                } else {
                  chavePix = value;
                }
              }),
              decoration: InputDecoration(
                labelText: 'key',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Total: \$$coinsWithdraw'),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  showConfirmDialog(
                      context, email, chavePix, coinsWithdraw!, address);
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16.0), // Raio dos cantos
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor,
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                child: const Text('Withdraw',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(ethUtilsProviders);
        final ethUtils = ref.read(ethUtilsProviders.notifier);
        EthereumAddress? myAddr = ethUtils.address;
        List<dynamic> balance = [];
        double balanceEth = 0.0;

        Future<void> getInfos() async {
          balance = await ethUtils.balanceOf(myAddr!);

          balanceEth = await ethUtils.weiToEth(balance[0]);
        }

        return Scaffold(
            body: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                title: const Text('Wallet'),
                centerTitle: true,
              ),
              const SizedBox(height: 20),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Sombra
                        spreadRadius: 1,
                        blurRadius: 5,
                        // Ajuste a sombra vertical aqui
                      ),
                    ],
                  ),
                  child: Center(
                    child: FutureBuilder(
                      future: getInfos(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return GradientText(
                            'GCOIN',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                            colors: [
                              Theme.of(context).primaryColor,
                              const Color.fromRGBO(61, 206, 252, 1),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return GradientText(
                            'GCOIN',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                            colors: [
                              Theme.of(context).primaryColor,
                              const Color.fromRGBO(61, 206, 252, 1),
                            ],
                          );
                        } else {
                          return GradientText(
                            'GCOIN ${balanceEth.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                            colors: [
                              Theme.of(context).primaryColor,
                              const Color.fromRGBO(61, 206, 252, 1),
                            ],
                          );
                        }
                      },
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            active = true;
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: active
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Deposit",
                          style: TextStyle(
                              color: active ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            active = false;
                          });
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: active
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Withdraw",
                          style: TextStyle(
                              color: active ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              active ? depositForm() : withdrawForm(),
            ],
          ),
        ));
      },
    );
  }
}

void showConfirmDialog(BuildContext context, info, pix, quantity, addr) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertCheck(
      email: info,
      chavePix: pix,
      creditos: quantity,
      address: addr,
    ),
  );
}

class AlertCheck extends StatelessWidget {
  final String email;
  final String chavePix;
  final double creditos;
  final String address;
  const AlertCheck(
      {super.key,
      required this.email,
      required this.chavePix,
      required this.creditos,
      required this.address});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(ethUtilsProviders);
        final ethUtils = ref.read(ethUtilsProviders.notifier);
        final transf = ethUtils.transfer;

        return AlertDialog(
          title: const Center(child: Text('Confirm your info!')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Value: \$$creditos',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'E-mail: $email',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'key: $chavePix',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'ATTENTION: The PIX key must refer to the account in which you wish to receive the amount, if the key is incorrect the amount may be lost (cell phone and CPF keys are accepted with or without the symbols, the important thing is that the number is correct! The amount will be deposited within 24 business hours!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                showLoadingDialog(context);
                try {
                  var tx = await transf(
                      EthereumAddress.fromHex(
                          "0x9127e5DD17033540450a0A58bb625C240D93C58e"),
                      BigInt.from(creditos));

                  await PaymentManager.makeWithdrawal(BigInt.from(creditos),
                      address, email, DateTime.now(), chavePix);
                  hideLoadingDialog(context);
                  showCheckDialog(context, 'Withdrawal request sent. Wait!');
                } catch (e) {
                  hideLoadingDialog(context);
                  showErrorDialog(context, e.toString());
                }
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
