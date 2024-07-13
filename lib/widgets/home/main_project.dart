import 'package:flutter/material.dart';
import 'package:goals_ethglobal/utils/eth_utils.dart';
import 'package:goals_ethglobal/widgets/home/progress_indicator.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainProjectInfo extends StatefulWidget {
  final int index;
  const MainProjectInfo({super.key, required this.index});

  @override
  State<MainProjectInfo> createState() => _MainProjectInfoState();
}

class _MainProjectInfoState extends State<MainProjectInfo> {
  @override
  Widget build(BuildContext context) {
    late int index;
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(ethUtilsProviders);
        final ethUtils = ref.watch(ethUtilsProviders.notifier);

        List<dynamic> myBet = [];
        List<dynamic> progress = [];

        Future<void> getInfos() async {
          progress = await ethUtils.getMyProgress(BigInt.from(index));
          myBet = await ethUtils.getMyBets(BigInt.from(index));
        }

        String title = 'title';
        String imgUrl = '1111111111111111111111111111111';
        int startTime = 0;
        double timer = 0;
        String metaType = '--';
        int vezes = 1;
        int metaU = 1;
        int meta = 0;
        int totalMeta = 1;
        String frequency = 'Diária';
        String fname = 'dia';
        List<dynamic> goal = [];

        if (ethUtils.goals.isEmpty) {
          index = -1;
        } else if (ethUtils.goals[0].isEmpty) {
          index = -1;
        } else {
          index = widget.index;
          if (index != -1) {
            final goal = ethUtils.goals[0][index];
            title = goal[1];
            imgUrl = goal[17][0];
            startTime = goal[7].toInt();
            metaType = goal[18];
            timer = (startTime - DateTime.now().millisecondsSinceEpoch) /
                (1000 * 60 * 60 * 24);

            vezes = goal[19].toInt();
            metaU = goal[20].toInt();
            meta = vezes * metaU;
            totalMeta = goal[5].toInt();
            frequency = goal[4];

            if (frequency == 'Diária') {
              fname = 'dia';
            } else if (frequency == 'Semanal') {
              fname = 'semana';
            } else if (frequency == 'Mensal') {
              fname = 'mês';
            } else {
              fname = '-';
            }
          }
        }

        return (index == -1)
            ? const Text('Encontre um projeto')
            : GestureDetector(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return StartedProject(
                  //         index: index,
                  //       );
                  //     },
                  //   ),
                  // );
                },
                child: Row(children: [
                  FutureBuilder(
                    future: getInfos(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const BuildProgressIndicator(percentage: 0.0);
                      } else if (snapshot.hasError) {
                        return const BuildProgressIndicator(percentage: 0.0);
                      } else {
                        int myProgress = progress[0].toInt();
                        double totalProgress = myProgress / totalMeta;

                        return BuildProgressIndicator(
                          percentage: totalProgress,
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$meta $metaType por $fname', // Valor do progresso (substitua pelo valor real)
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder(
                        future: getInfos(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text(
                              'Aposta R\$-- ', // Valor do progresso (substitua pelo valor real)
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return const Text(
                              'Aposta R\$--', // Valor do progresso (substitua pelo valor real)
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            );
                          } else {
                            double myBetValue =
                                myBet[0] / BigInt.from(10).pow(18);

                            return Text(
                              'Aposta R\$$myBetValue ', // Valor do progresso (substitua pelo valor real)
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ]),
              );
      },
    );
  }
}
