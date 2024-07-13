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
          'December'
        ];
        final int startTime = goal[7].toInt();
        final DateTime startDate =
            DateTime.fromMillisecondsSinceEpoch(startTime);
        final String formatStart =
            '${startDate.day} of ${monthNames[startDate.month - 1]}';
        final int endTime = goal[8].toInt();
        final DateTime endDate = DateTime.fromMillisecondsSinceEpoch(endTime);
        final double timer = (endTime - DateTime.now().millisecondsSinceEpoch) /
            (1000 * 60 * 60 * 24);
        final double timerStart =
            (startTime - DateTime.now().millisecondsSinceEpoch) /
                (1000 * 60 * 60 * 24);
        final String formatEnd =
            '${endDate.day} of ${monthNames[endDate.month - 1]} of ${endDate.year}';

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

        if (frequency == 'Daily') {
          passTime = passDays;
          totalTime = totalDays;
          fname = 'day';
          fplural = 'Days';
        } else if (frequency == 'Weekly') {
          passTime = passWeeks;
          totalTime = totalWeeks;
          fname = 'week';
          fplural = 'Weeks';
        } else if (frequency == 'Monthly') {
          passTime = passMonths;
          totalTime = totalMonths;
          fname = 'month';
          fplural = 'Months';
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
                "Rules and Conditions",
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
                        "Find out more about the rules and conditions of the challenge.",
                      )),
                      const SizedBox(width: 5),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Rules and Conditions'),
                                content: SizedBox(
                                  height: 200,
                                  child: SingleChildScrollView(
                                    child: Text(
                                        "Send $vezes photos per $fname to validate the challenge. This photo must be clear and show some moment of completing the challenge, you don't need to demonstrate each moment of the challenge, for example, if the challenge is to run 5km, you don't need to take 5 photos of 1km, just one photo that shows that you ran. If the photo is not clear or does not show the moment the challenge was completed, the photo will be invalidated. If you do not send the photo you will lose validation. If you do not complete the minimum number of validations of 85%, the bet amount will be distributed among the other participants. If you complete 100% you will receive an extra reward in credits that can be redeemed in \$"),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Close'),
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
                          "Read",
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
                              child: const Text('Validate',
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
                      "$meta $metaType by $fname",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Created by $creator",
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
                          "By $formatStart to $formatEnd",
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
                                            "${timerStart.toStringAsFixed(0)} days to start",
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
                                            "Remains ${timer.toStringAsFixed(0)} days",
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
                                        const Text("Conclude"),
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
                                        const Text("Bet"),
                                        Text(
                                          "\$ $myBetValue",
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
                                "Project concluded",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "The challenge was completed successfully. If you complete more than 85% of the validations you will receive your bet amount back. If you completed 100% you will receive an extra reward in credits that can be redeemed in R\$. If you did not complete 85% of the challenge you will lose the bet amount.",
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
