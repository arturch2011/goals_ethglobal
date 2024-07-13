import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goals_ethglobal/providers/user_info_provider.dart';
import 'package:goals_ethglobal/screens/camera_screen.dart';
import 'package:goals_ethglobal/utils/eth_utils.dart';
import 'package:goals_ethglobal/widgets/home/progress_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:provider/provider.dart';

class StartedProject extends StatefulWidget {
  final int index;
  const StartedProject({super.key, required this.index});

  @override
  State<StartedProject> createState() => _StartedProjectState();
}

class _StartedProjectState extends State<StartedProject> {
  @override
  Widget build(BuildContext context) {
    final int index = widget.index;
    final photoList = Provider.of<UserProvider>(context).photoList;
    return riverpod.Consumer(
      builder: (context, ref, child) {
        ref.read(ethUtilsProviders);
        final ethUtils = ref.read(ethUtilsProviders.notifier);
        List<dynamic> progress = [];
        List<dynamic> myBet = [];
        // List<dynamic> myUris = [];

        Future<void> getInfos() async {
          progress = await ethUtils.getMyProgress(BigInt.from(index));
          myBet = await ethUtils.getMyBets(BigInt.from(index));
          print('111111111111111111111 $progress');
          print("2222222222222222 $myBet");
        }

        final goal = ethUtils.goals[0][index];
        final String title = goal[1];
        final String imgUrl = goal[17][0];
        final int vezes = goal[19].toInt();
        final int metaU = goal[20].toInt();
        final int meta = vezes * metaU;
        final bool isFinished = goal[10];
        final int totalMeta = goal[5].toInt();
        final String metaType = goal[18];
        // final int minValue = goal[6].toInt();
        final String creator = "${goal[12].toString().substring(0, 10)}...";
        final double totalBet = goal[13] / BigInt.from(10).pow(18);
        // final int preFound = goal[14].toInt();
        final int totalParticipants = goal[15].toInt();
        // final int maxParticipants = goal[16].toInt();
        // final String description = goal[2];
        var monthNames = [
          'Janeiro',
          'Fevereiro',
          'Março',
          'Abril',
          'Maio',
          'Junho',
          'Julho',
          'Agosto',
          'Setembro',
          'Outubro',
          'Novembro',
          'Dezembro'
        ];
        final int startTime = goal[7].toInt();
        final DateTime startDate =
            DateTime.fromMillisecondsSinceEpoch(startTime);
        final String formatStart =
            '${startDate.day} de ${monthNames[startDate.month - 1]}';
        final int endTime = goal[8].toInt();
        final DateTime endDate = DateTime.fromMillisecondsSinceEpoch(endTime);
        final double timer = (endTime - DateTime.now().millisecondsSinceEpoch) /
            (1000 * 60 * 60 * 24);
        final double timerStart =
            (startTime - DateTime.now().millisecondsSinceEpoch) /
                (1000 * 60 * 60 * 24);
        final String formatEnd =
            '${endDate.day} de ${monthNames[endDate.month - 1]} de ${endDate.year}';

        final String passDays =
            (DateTime.now().millisecondsSinceEpoch - startTime > 0)
                ? ((DateTime.now().millisecondsSinceEpoch - startTime) ~/
                        (1000 * 60 * 60 * 24))
                    .toString()
                : '0';
        final String passWeeks =
            (DateTime.now().millisecondsSinceEpoch - startTime > 0)
                ? ((DateTime.now().millisecondsSinceEpoch - startTime) ~/
                        (1000 * 60 * 60 * 24 * 7))
                    .toString()
                : '0';
        final String passMonths =
            (DateTime.now().millisecondsSinceEpoch - startTime > 0)
                ? ((DateTime.now().millisecondsSinceEpoch - startTime) ~/
                        (1000 * 60 * 60 * 24 * 30))
                    .toString()
                : '0';
        final int totalDays = (endTime - startTime) / (1000 * 60 * 60 * 24) > 0
            ? (endTime - startTime) ~/ (1000 * 60 * 60 * 24)
            : 0;
        final int totalWeeks =
            (endTime - startTime) / (1000 * 60 * 60 * 24 * 7) > 0
                ? (endTime - startTime) ~/ (1000 * 60 * 60 * 24 * 7)
                : 0;
        final int totalMonths =
            (endTime - startTime) / (1000 * 60 * 60 * 24 * 30) > 0
                ? (endTime - startTime) ~/ (1000 * 60 * 60 * 24 * 30)
                : 0;
        final String frequency = goal[4];
        late String fname;
        late String fplural;
        late String passTime;
        late int totalTime;

        if (frequency == 'Diária') {
          passTime = passDays;
          totalTime = totalDays;
          fname = 'dia';
          fplural = 'Dias';
        } else if (frequency == 'Semanal') {
          passTime = passWeeks;
          totalTime = totalWeeks;
          fname = 'semana';
          fplural = 'Semanas';
        } else if (frequency == 'Mensal') {
          passTime = passMonths;
          totalTime = totalMonths;
          fname = 'mês';
          fplural = 'Mêses';
        } else {
          passTime = '-';
          totalTime = 0;
          fname = '-';
          fplural = '-';
        }

        // final int metaTotal = meta * totalTime;

        Future<bool> getUris() async {
          bool result = false;
          // double quantity = vezes * (double.parse(passTime).toInt() + 1);
          // String address = ethUtils.publicAddr;
          // myUris = await ethUtils.getParticipantsUri(index, address);
          // if (myUris[0].length < quantity) {
          //   result = true;
          // }
          result = !photoList.any((element) =>
              element.index == index && element.date == DateTime.now().day);
          return result;
        }

        Widget incomplete() {
          return Column(
            children: [
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      const SizedBox(width: 5),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Regras e Condições'),
                                content: SizedBox(
                                  height: 200,
                                  child: SingleChildScrollView(
                                    child: Text(
                                        "Envie $vezes foto por $fname para validar o desafio. Essa foto deve ser nítida e mostrar algum momento de realização do desafio, você não precisa demonstrar cada momento do desafio exemplo se o desafio for correr 5km você não precisa tirar 5 fotos de 1km, basta uma foto que mostre que você correu. Caso a foto não seja nítida ou não mostre o momento de realização do desafio, a foto será invalidada. Caso você não envie a foto voce perderá uma validação. Caso você não conclua o número mínimo de validações de 85% o valor da aposta será distribuído entre os outros participantes. Se você concluir 100% recebera uma recompensa extra em créditos que poderam ser resgatados em R\$"),
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
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: FutureBuilder(
                  future: getUris(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      bool result = snapshot.data as bool;
                      return result
                          ? TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CameraApp(index: index);
                                    },
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        16.0), // Raio dos cantos
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor,
                                ),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                              child: const Text('Validar',
                                  style: TextStyle(color: Colors.white)),
                            )
                          : TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        16.0), // Raio dos cantos
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.green,
                                ),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 16),
                                ),
                              ),
                              child:
                                  const Icon(Icons.check, color: Colors.white),
                            );
                    }
                  },
                ),
              ),
            ],
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
              child: Column(
            children: [
              Stack(children: [
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
                        Color.fromARGB(195, 255, 255, 255),
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
                          info: '$totalParticipants participando',
                        ),
                        const SizedBox(width: 10),
                        BlocosInformativos(
                          info: 'R\$$totalBet arrecadado',
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
                    FutureBuilder(
                      future: getInfos(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          int progressValue = progress[0].toInt();
                          int progressFull = progressValue * metaU;
                          double myBetValue =
                              myBet[0] / BigInt.from(10).pow(18);
                          double percentProgress = progressValue / totalMeta;
                          // double totalProgress =
                          //     progressValue / (meta * totalTime);
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(25, 8, 25, 25),
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
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(Icons.access_time_rounded,
                                        color: Color.fromARGB(255, 99, 99, 99),
                                        size: 15),
                                    const SizedBox(width: 2),
                                    timer > totalDays
                                        ? Text(
                                            "${timerStart.toStringAsFixed(0)} dias para começar",
                                            textHeightBehavior:
                                                const TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        true,
                                                    applyHeightToLastDescent:
                                                        false),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 99, 99, 99),
                                            ),
                                          )
                                        : Text(
                                            "Restam ${timer.toStringAsFixed(0)} dias",
                                            textHeightBehavior:
                                                const TextHeightBehavior(
                                                    applyHeightToFirstAscent:
                                                        true,
                                                    applyHeightToLastDescent:
                                                        false),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color.fromARGB(
                                                  255, 99, 99, 99),
                                            ),
                                          ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BuildProgressIndicator(
                                      percentage: percentProgress,
                                    ),
                                    Column(
                                      children: [
                                        const Text("Concluído"),
                                        Text(
                                          "$progressFull $metaType ",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(fplural),
                                        Text(
                                          passTime,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Text("Aposta"),
                                        Text(
                                          "R\$ $myBetValue",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    // const SizedBox(height: 20),
                    // const Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     DiaDaSemanaWidget(
                    //         estado: EstadoDia.naoConcluido, diaSemana: "1"),
                    //     DiaDaSemanaWidget(
                    //         estado: EstadoDia.concluido, diaSemana: "2"),
                    //     DiaDaSemanaWidget(
                    //         estado: EstadoDia.concluido, diaSemana: "3"),
                    //     DiaDaSemanaWidget(
                    //         estado: EstadoDia.diaAtual, diaSemana: "4"),
                    //     DiaDaSemanaWidget(
                    //         estado: EstadoDia.naoIniciado, diaSemana: "5"),
                    //     DiaDaSemanaWidget(
                    //         estado: EstadoDia.naoIniciado, diaSemana: "6"),
                    //     DiaDaSemanaWidget(
                    //         estado: EstadoDia.naoIniciado, diaSemana: "7"),
                    //   ],
                    // ),
                    const SizedBox(height: 16),
                    isFinished
                        ? const Column(
                            children: [
                              Text(
                                "Desafio Concluído",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "O desafio foi concluido com sucesso. Se você conclui mais de 85% das validações você receberá o valor da aposta de volta. Se concluiu 100% você receberá uma recompensa extra em créditos que poderam ser resgatados em R\$ se você não concluiu 85% Do desafio você perderá o valor da aposta.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : incomplete(),
                  ],
                ),
              )
            ],
          )),
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
