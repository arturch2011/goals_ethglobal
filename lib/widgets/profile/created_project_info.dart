import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goals_ethglobal/utils/eth_utils.dart';
import 'package:goals_ethglobal/widgets/loading_popup.dart';

class CreatedCard extends StatefulWidget {
  final int index;
  const CreatedCard({super.key, required this.index});

  @override
  State<CreatedCard> createState() => _CreatedCardState();
}

class _CreatedCardState extends State<CreatedCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      ref.watch(ethUtilsProviders);
      final ethUtils = ref.watch(ethUtilsProviders.notifier);
      final int index = widget.index;

      void startGoal() async {
        showLoadingDialog(context);
        try {
          await ethUtils.startGoal(BigInt.from(index));
          hideLoadingDialog(context);
          showCheckDialog(context, 'Started with success !');
        } catch (e) {
          hideLoadingDialog(context);
          showErrorDialog(context, e.toString());
        }
      }

      void endGoal() async {
        showLoadingDialog(context);
        try {
          await ethUtils.completeGoal(BigInt.from(index));
          hideLoadingDialog(context);
          showCheckDialog(context, 'Finalized with success !');
        } catch (e) {
          hideLoadingDialog(context);
          showErrorDialog(context, e.toString());
        }
      }

      List<dynamic> goals = ethUtils.goals[0][index];

      final String title = goals[1];
      final int startTime = goals[7].toInt();
      final int endTime = goals[8].toInt();
      final bool isStarted = goals[9];
      final bool isFinished = goals[10];
      final String metaType = goals[18];
      final double timer = (startTime - DateTime.now().millisecondsSinceEpoch) /
          (1000 * 60 * 60 * 24);
      final double endTimer =
          (endTime - DateTime.now().millisecondsSinceEpoch) /
              (1000 * 60 * 60 * 24);

      final int vezes = goals[19].toInt();
      final int metaU = goals[20].toInt();
      final int meta = vezes * metaU;
      final bool isPublic = goals[11];
      final double totalBet = goals[13] / BigInt.from(10).pow(18);
      final double preFound = goals[14] / BigInt.from(10).pow(18);
      final int totalParticipants = goals[15].toInt();
      final String frequency = goals[4];
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

      return Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              '$meta $metaType per $fname', // Valor do progresso (substitua pelo valor real)
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            if (endTimer > 0)
              Container(
                child: timer < 0
                    ? Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 15),
                              Text(
                                '${endTimer.toStringAsFixed(0)}d',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded, size: 15),
                              Text(
                                '${timer.toStringAsFixed(0)}d',
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              )
          ],
        ),
        const SizedBox(width: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Initial value: \$$preFound', // Valor do progresso (substitua pelo valor real)
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
                Text(
                  'Locked value: \$$totalBet', // Valor do progresso (substitua pelo valor real)
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
                Text(
                  'Total participants: $totalParticipants', // Valor do progresso (substitua pelo valor real)
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
                Text(
                  isPublic
                      ? 'Public'
                      : 'Private', // Valor do progresso (substitua pelo valor real)
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            endTimer > 0
                ? timer < 1
                    ? isStarted
                        ? const Text('Project started')
                        : TextButton(
                            onPressed: () => startGoal(),
                            style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Iniciar",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                    : const Text(
                        'Whait the initial date to start the project',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      )
                : isFinished
                    ? const Text('Project concluded')
                    : TextButton(
                        onPressed: () => endGoal(),
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Finalize",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
          ],
        ),
      ]);
    });
  }
}
