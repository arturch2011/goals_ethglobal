import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goals_ethglobal/screens/all_projects_screen.dart';
import 'package:goals_ethglobal/utils/eth_utils.dart';
import 'package:goals_ethglobal/widgets/home/project_card.dart';
import 'package:goals_ethglobal/widgets/search_popup.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final List<String> categories = const [
    'Exercise',
    'Routine',
    'Studies',
    'Reading'
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(ethUtilsProviders);
        final ethUtils = ref.watch(ethUtilsProviders.notifier);
        final List<dynamic> goal = ethUtils.goals[0];
        if (goal.isNotEmpty) {
          final List<dynamic> unstartedGoals = goal
              .where((element) =>
                  (element[7].toInt() - DateTime.now().millisecondsSinceEpoch) /
                      (1000 * 60 * 60 * 24) >
                  0)
              .toList();
          final List<dynamic> publicGoals =
              unstartedGoals.where((element) => element[11] == true).toList();
          final List<dynamic> exerciseList =
              publicGoals.where((element) => element[3] == 'Exercise').toList();
          final List<dynamic> rotinList =
              publicGoals.where((element) => element[3] == 'Routine').toList();
          final List<dynamic> studiesList =
              publicGoals.where((element) => element[3] == 'Studies').toList();
          final List<dynamic> readList =
              publicGoals.where((element) => element[3] == 'Reading').toList();

          if (publicGoals.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text('No projects found'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Search privates',
                    ),
                    IconButton(
                        onPressed: () {
                          _showPicker(context, unstartedGoals);
                        },
                        icon: const Icon(
                          Icons.search,
                          size: 27,
                        )),
                  ],
                ),
              ],
            );
          } else {
            print(unstartedGoals[unstartedGoals.length - 1]);

            return SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 40,
                              ),
                              Center(
                                  child: Text(
                                "Projects",
                                style: Theme.of(context).textTheme.titleLarge,
                              )),
                              IconButton(
                                  onPressed: () {
                                    _showPicker(context, unstartedGoals);
                                  },
                                  icon: const Icon(
                                    Icons.search,
                                    size: 27,
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                final category = categories[index];
                                late List<dynamic> categoryList;
                                if (category == 'Exercise') {
                                  categoryList = exerciseList;
                                } else if (category == 'Routine') {
                                  categoryList = rotinList;
                                } else if (category == 'Studies') {
                                  categoryList = studiesList;
                                } else {
                                  categoryList = readList;
                                }
                                final int categoryListLength =
                                    categoryList.length - 1;
                                final int categoryListLength2 =
                                    categoryList.length - 2;
                                final int goalsIndex;
                                final int goalsIndex2;
                                if (categoryList.isEmpty) {
                                  goalsIndex = -1;
                                  goalsIndex2 = -1;
                                } else if (categoryList.length == 1) {
                                  goalsIndex = categoryList[categoryListLength]
                                          [0]
                                      .toInt();
                                  goalsIndex2 = -1;
                                } else {
                                  goalsIndex = categoryList[categoryListLength]
                                          [0]
                                      .toInt();
                                  goalsIndex2 =
                                      categoryList[categoryListLength2][0]
                                          .toInt();
                                }

                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          category,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () => {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return AllProjectsScreen(
                                                    goalsList: categoryList,
                                                    title: "$category Projects",
                                                  );
                                                },
                                              ),
                                            )
                                          },
                                          child: const Text(
                                            'See more',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Color.fromRGBO(
                                                  156, 156, 156, 1),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ProjectCard(
                                            index: goalsIndex,
                                          ),
                                          const SizedBox(width: 10),
                                          ProjectCard(
                                            index: goalsIndex2,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (index == categories.length - 1)
                                      const SizedBox(height: 80),
                                  ],
                                );
                              }),
                        ),
                      ],
                    )));
          }
        } else {
          return const Center(
            child: Text('No projects found'),
          );
        }
      },
    );
  }

  void _showPicker(BuildContext context, List<dynamic> unstartedGoalss) {
    showDialog(
      context: context,
      builder: (context) => MyDialog(unstartedGoals: unstartedGoalss),
    );
  }
}
