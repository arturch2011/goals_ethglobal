import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goals_ethglobal/providers/user_info_provider.dart';
import 'package:goals_ethglobal/utils/eth_utils.dart';
import 'package:goals_ethglobal/widgets/loading_popup.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as prov;

class ProjectDetails extends StatefulWidget {
  final int index;
  const ProjectDetails({super.key, required this.index});

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  @override
  Widget build(BuildContext context) {
    final int index = widget.index;
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(ethUtilsProviders);
        final ethUtils = ref.watch(ethUtilsProviders.notifier);
        final goal = ethUtils.goals[0][index];
        final String title = goal[1];
        final String imgUrl = goal[17][0];

        final String metaType = goal[18];
        final int vezes = goal[19].toInt();
        final int metaU = goal[20].toInt();
        final int meta = vezes * metaU;
        final double minValue = goal[6] / BigInt.from(10).pow(18);
        final String creator = "${goal[12].toString().substring(0, 10)}...";
        final double totalBet = goal[13] / BigInt.from(10).pow(18);
        // final int preFound = goal[14].toInt();
        final int totalParticipants = goal[15].toInt();
        // final int maxParticipants = goal[16].toInt();
        final String description = goal[2];
        var monthNames = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
        final int startTime = goal[7].toInt();
        final DateTime startDate =
            DateTime.fromMillisecondsSinceEpoch(startTime);
        final String formatStart =
            '${startDate.day} of ${monthNames[startDate.month - 1]}';
        final int endTime = goal[8].toInt();
        final DateTime endDate = DateTime.fromMillisecondsSinceEpoch(endTime);
        final String formatEnd =
            '${endDate.day} of ${monthNames[endDate.month - 1]} of ${endDate.year}';
        final String frequency = goal[4];
        late String fname;

        if (frequency == 'Daily') {
          fname = 'day';
        } else if (frequency == 'Weekly') {
          fname = 'week';
        } else if (frequency == 'Monthly') {
          fname = 'month';
        } else {
          fname = '-';
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(children: [
                  // Container(
                  //   height: MediaQuery.of(context).size.height / 3,
                  //   decoration: const BoxDecoration(
                  //     image: DecorationImage(
                  //       image: AssetImage(
                  //           "assets/images/image1.png"), // Substitua 'imagem.jpg' pela imagem desejada.
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  imgUrl.substring(0, 28) == 'https://gateway.pinata.cloud'
                      ? Image.network(imgUrl,
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height / 3,
                          width: double.infinity)
                      : Image.asset('assets/images/splash_image2.png',
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height / 3,
                          width: double.infinity),
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 255,
                              255), // Cor de fundo gradiente - começo
                          Color.fromARGB(75, 255, 255, 255),
                          Color.fromARGB(0, 255, 255, 255),
                          Color.fromARGB(0, 255, 255,
                              255), // Cor de fundo gradiente - começo
                          Color.fromARGB(
                              0, 255, 255, 255), // Cor de fundo gradiente - fim
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: AppBar(
                      title: Text(title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )),
                      // actions: [
                      //   IconButton(
                      //     onPressed: () {
                      //       // Ação do botão de menu.
                      //     },
                      //     icon: SvgPicture.asset(
                      //       'assets/icons/upload.svg',
                      //       width: 20,
                      //     ),
                      //   ),
                      //   IconButton(
                      //     onPressed: () {
                      //       // Ação do botão de menu.
                      //     },
                      //     icon: SvgPicture.asset(
                      //       'assets/icons/heart.svg',
                      //       width: 20,
                      //     ),
                      //   ),
                      // ],
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ]),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$meta $metaType por $fname",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Criado por $creator",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocosInformativos(
                            info: '$totalParticipants participating',
                          ),
                          const SizedBox(width: 10),
                          BlocosInformativos(
                            info: 'R\$$totalBet locked',
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/calendar.svg',
                            width: 20,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            "De $formatStart até $formatEnd",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(240, 240, 240, 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              description,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  _showInvestDialog(context, index, minValue);
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Participar",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Regras e condições",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(240, 240, 240, 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Flexible(
                                  child: Text(
                                "Saiba mais sobre as regras e condições do desafio.",
                              )),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Rules'),
                                        content: SizedBox(
                                          height: 200,
                                          child: SingleChildScrollView(
                                            child: Text(
                                                "Envie $vezes foto por $fname para validar o desafio. Essa foto deve ser nítida e mostrar algum momento de realização do desafio, você não precisa demonstrar cada momento do desafio exemplo se o desafio for correr 5km você não precisa tirar 5 fotos de 1km, basta uma foto que mostre que você correu. Caso a foto não seja nítida ou não mostre o momento de realização do desafio, a foto será invalidada. Caso você não envie a foto voce perderá uma validação. Caso você não conclua o número mínimo de validações de 85% o valor da aposta será distribuído entre os outros participantes. Se você concluir 100% recebera uma recompensa extra em créditos que poderam ser resgatados em R\$."),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Fechar'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                style: TextButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.black, // Cor da borda
                                    width: 1.0, // Largura da borda
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  "Ler",
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          )),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BlocosInformativos extends StatelessWidget {
  final String info;
  const BlocosInformativos({super.key, required this.info});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
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
          child: Text(
            info,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

void _showInvestDialog(context, goalIndex, minBet) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return BottomPop(
          index: goalIndex,
          minvalue: minBet,
        );
      });
}

class BottomPop extends StatefulWidget {
  final int index;
  final double minvalue;
  const BottomPop({super.key, required this.index, required this.minvalue});

  @override
  State<BottomPop> createState() => _BottomPopState();
}

class _BottomPopState extends State<BottomPop> {
  String valorSelecionado = valores[0];

  @override
  Widget build(BuildContext context) {
    final int index = widget.index;
    return Container(
      width: double.infinity,
      height: 300,
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Valores recomendados", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: Row(
              children: valores
                  .take(3) // Pegue apenas os 3 primeiros valores
                  .map((value) {
                final isSelected = valorSelecionado == value;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        valorSelecionado = value;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "R\$$value",
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                valorSelecionado = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Outro valor', // Placeholder
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6), // Espaçamento interno
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0), // Borda arredondada
                borderSide:
                    const BorderSide(color: Colors.grey), // Cor da borda padrão
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0), // Borda arredondada
                borderSide: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .primary), // Cor da borda quando em foco
              ),
            ),
          ),
          const SizedBox(height: 5),
          Align(
              alignment: Alignment.centerRight,
              child: Text("Valor Minimo: R\$${widget.minvalue}",
                  style: const TextStyle(fontSize: 12))),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                _showConfirmDialog(context, valorSelecionado, index);
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
              child: const Text('Apostar',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}

void _showConfirmDialog(context, valor, goalIndex) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ConfirmPop(
          valorFinal: valor,
          index: goalIndex,
        );
      });
}

class ConfirmPop extends StatefulWidget {
  final String valorFinal;
  final int index;
  const ConfirmPop({super.key, required this.valorFinal, required this.index});

  @override
  State<ConfirmPop> createState() => _ConfirmPopState();
}

class _ConfirmPopState extends State<ConfirmPop> {
  @override
  Widget build(BuildContext context) {
    String email = 'email';

    try {
      email = prov.Provider.of<UserProvider>(context).userInfos[0]['userInfo']
          ["email"];
    } catch (e) {
      email = '';
    }
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(ethUtilsProviders);
        final ethUtils = ref.watch(ethUtilsProviders.notifier);
        final goal = ethUtils.goals[0][widget.index];
        final String frequency = goal[4];
        late String fname;

        if (frequency == 'Diária') {
          fname = 'dia';
        } else if (frequency == 'Semanal') {
          fname = 'semana';
        } else if (frequency == 'Mensal') {
          fname = 'mês';
        } else {
          fname = '-';
        }
        final int meta = goal[19].toInt() * goal[20].toInt();
        final String metaType = goal[18];

        return Container(
          width: double.infinity,
          height: 300,
          padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text("Voce deseja apostar", style: TextStyle(fontSize: 22)),
              Text("R\$${widget.valorFinal}",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              Text("em '$meta $metaType por $fname'?",
                  style: const TextStyle(fontSize: 22)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    showLoadingDialog(context);
                    try {
                      await ethUtils.enterGoal(BigInt.from(widget.index),
                          double.parse(widget.valorFinal));

                      var url = Uri.parse(
                          'https://us-central1-goals-e4200.cloudfunctions.net/addEventToUser');
                      var config = {
                        'email': email,
                        'eventId': goal[0].toString(),
                        'eventName': goal[1],
                        'address': ethUtils.addr,
                      };
                      var headers = {
                        'Content-Type': 'application/x-www-form-urlencoded',
                      };
                      var response =
                          await http.post(url, headers: headers, body: config);
                      print('Response status: ${response.statusCode}');
                      hideLoadingDialog(context);
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      showCheckDialog(context, 'Você entrou no desafio!');
                    } catch (e) {
                      hideLoadingDialog(context);
                      showErrorDialog(context, e.toString());
                    }
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
                  child: const Text('Confirmar',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).primaryColor, // Cor da borda
                      width: 1.0, // Largura da borda
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Alterar valor',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

List<String> valores = ['5', '10', '20'];
