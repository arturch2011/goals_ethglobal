import 'package:flutter/material.dart';
import 'package:goals_ethglobal/screens/project_details_screen.dart';
import 'package:goals_ethglobal/utils/eth_utils.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectCard extends StatefulWidget {
  final int index;
  const ProjectCard({super.key, required this.index});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  @override
  Widget build(BuildContext context) {
    late int index;

    return Consumer(
      builder: (context, ref, child) {
        ref.watch(ethUtilsProviders);
        final ethUtils = ref.watch(ethUtilsProviders.notifier);
        // late final List<dynamic> goal;
        // late final String title;
        // late final BigInt startTime;

        String title = 'title';
        String imgUrl = '1111111111111111111111111111111';
        int startTime = 0;
        double timer = 0;
        int vezes = 1;
        int metaU = 1;
        int meta = 0;
        String metaType = '--';
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
            timer = (startTime - DateTime.now().millisecondsSinceEpoch) /
                (1000 * 60 * 60 * 24);
            vezes = goal[19].toInt();
            metaU = goal[20].toInt();
            meta = vezes * metaU;
            metaType = goal[18];
            frequency = goal[4];

            if (frequency == 'Daily') {
              fname = 'day';
            } else if (frequency == 'Weekly') {
              fname = 'week';
            } else if (frequency == 'Monthly') {
              fname = 'month';
            } else {
              fname = '-';
            }
          }
        }

        return Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return ProjectDetails(index: index);
                  },
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
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
              child: (index == -1)
                  ? const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                      child: Text('No projects found'),
                    )
                  : Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: imgUrl.substring(0, 28) ==
                                  'https://gateway.pinata.cloud'
                              ? Image.network(imgUrl,
                                  fit: BoxFit.cover,
                                  height: 150,
                                  width: double.infinity)
                              : Image.asset('assets/images/splash_image2.png',
                                  fit: BoxFit.cover,
                                  height: 150,
                                  width: double.infinity),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time_rounded,
                                          size: 15),
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
                              Text(
                                '$meta $metaType by $fname', // Valor do progresso (substitua pelo valor real)
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) {
                                    //       return ProjectDetails(index: index);
                                    //     },
                                    //   ),
                                    // );
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Participate",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
