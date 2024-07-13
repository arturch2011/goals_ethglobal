import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goals_ethglobal/providers/user_info_provider.dart';
import 'package:goals_ethglobal/screens/menu_screen.dart';
import 'package:goals_ethglobal/utils/eth_utils.dart';
import 'package:goals_ethglobal/widgets/home/carousel.dart';
import 'package:goals_ethglobal/widgets/home/main_project.dart';
import 'package:goals_ethglobal/widgets/home/profile_avatar.dart';
import 'package:goals_ethglobal/widgets/home/project_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Widget buildRecommendedExercises() {
    return const Row(
      children: [
        Text(
          'You May Also Like',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        // const Spacer(),
        // GestureDetector(
        //   onTap: () => {},
        //   child: const Text(
        //     'Ver mais',
        //     style: TextStyle(
        //       fontSize: 17,
        //       color: Color.fromRGBO(156, 156, 156, 1),
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(ethUtilsProviders);
    final ethUtils = ref.read(ethUtilsProviders.notifier);
    ethUtils.getGoals();
    ethUtils.getMyEnteredGoals();
    ethUtils.getMyGoals();
    List<dynamic> myGoals = [];
    List<dynamic> goals = [];
    List<dynamic> unstartedGoals = [];
    List<dynamic> publicGoals = [];
    String? completeName;
    try {
      completeName =
          context.watch<UserProvider>().userInfos[0]['userInfo']["name"];
    } catch (e) {
      completeName = null;
    }

    final String nullName;
    completeName == null ? nullName = "Usuário" : nullName = completeName;
    List<String> names = nullName.split(" ");
    final String firstName = names[0];

    goals = ethUtils.goals;
    myGoals = ethUtils.myEnteredGoals;
    int goalsLength;
    int goalsLength2;
    int lastGoalIndex = -1;

    if (goals.isNotEmpty) {
      final List<dynamic> goal = goals[0];
      unstartedGoals = goal
          .where((element) =>
              (element[7].toInt() - DateTime.now().millisecondsSinceEpoch) /
                  (1000 * 60 * 60 * 24) >
              0)
          .toList();
      publicGoals =
          unstartedGoals.where((element) => element[11] == true).toList();
      if (publicGoals.isEmpty) {
        goalsLength = -1;
        goalsLength2 = -1;
      } else if (publicGoals.length == 1) {
        goalsLength = publicGoals[publicGoals.length - 1][0].toInt();
        goalsLength2 = -1;
      } else {
        goalsLength = publicGoals[publicGoals.length - 1][0].toInt();
        goalsLength2 = publicGoals[publicGoals.length - 2][0].toInt();
      }
    } else {
      goalsLength = -1;
      goalsLength2 = -1;
    }

    if (myGoals.isEmpty) {
      lastGoalIndex = -1;
    } else if (myGoals[0].isEmpty) {
      lastGoalIndex = -1;
    } else {
      lastGoalIndex = myGoals[0][myGoals[0].length - 1].toInt();
    }

    // if (goals.isEmpty) {
    //   goalsLength = -1;
    //   goalsLength2 = -1;
    // } else if (goals[0].length <= 1) {
    //   goalsLength = goals[0].length - 1;
    //   goalsLength2 = -1;
    // } else {
    //   goalsLength = goals[0].length - 1;
    //   goalsLength2 = goals[0].length - 2;
    // if (myGoals.isEmpty) {
    //   lastGoalIndex = -1;
    // } else if (myGoals[0].isEmpty) {
    //   lastGoalIndex = -1;
    // } else {
    //   lastGoalIndex = myGoals[0][myGoals[0].length - 1].toInt();
    // }
    // }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Row(
              children: [
                const BuildProfileAvatar(
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  'Hello, $firstName!',
                  textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: true,
                      applyHeightToLastDescent: false),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const Menu();
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
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
                      child: Row(
                        children: [
                          MainProjectInfo(
                            index: lastGoalIndex,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const CarouselWithIndicatorDemo(),
                    const SizedBox(height: 20),
                    buildRecommendedExercises(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProjectCard(index: goalsLength),
                          const SizedBox(width: 10),
                          ProjectCard(index: goalsLength2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
