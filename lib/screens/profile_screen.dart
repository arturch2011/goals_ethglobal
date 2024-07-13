import 'package:flutter/material.dart';
import 'package:goals_ethglobal/providers/user_info_provider.dart';
import 'package:goals_ethglobal/screens/create_screen.dart';
import 'package:goals_ethglobal/screens/menu_screen.dart';
import 'package:goals_ethglobal/utils/eth_utils.dart';
import 'package:goals_ethglobal/widgets/home/main_project.dart';
import 'package:goals_ethglobal/widgets/home/profile_avatar.dart';
import 'package:goals_ethglobal/widgets/profile/created_project_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:web3dart/web3dart.dart';
import 'package:clipboard/clipboard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String statusSelecionado = 'Active';
  String statusSelecionado2 = 'In progress';
  @override
  Widget build(BuildContext context) {
    String? name;
    String? email;

    try {
      name = context.watch<UserProvider>().userInfos[0]['userInfo']["name"];
      email = context.watch<UserProvider>().userInfos[0]['userInfo']["email"];
    } catch (e) {
      name = null;
      email = null;
    }

    final String nameFinal;

    name == null ? nameFinal = "User" : nameFinal = name;

    final String emailFinal;

    email == null ? emailFinal = "@" : emailFinal = email;

    return riverpod.Consumer(
      builder: (context, ref, child) {
        ref.watch(ethUtilsProviders);
        final ethUtils = ref.read(ethUtilsProviders.notifier);
        List<dynamic> myGoals = ethUtils.myEnteredGoals[0];
        List<dynamic> myCreatedGoals = ethUtils.myCreatedGoals[0];
        List<dynamic> goals = ethUtils.goals[0];
        String address = ethUtils.publicAddr;
        EthereumAddress? myAddr = ethUtils.address;
        List<dynamic> balance = [];
        double balanceEth = 0;

        Future<void> getInfos() async {
          balance = await ethUtils.balanceOf(myAddr!);
          balanceEth = await ethUtils.weiToEth(balance[0]);
        }

        final List<dynamic> myGoalsList =
            goals.where((element) => myGoals.contains(element[0])).toList();
        final List<dynamic> myCreatedList = goals
            .where((element) => myCreatedGoals.contains(element[0]))
            .toList();
        final List<dynamic> inProgressGoals = myGoalsList
            .where((element) =>
                (element[8].toInt() - DateTime.now().millisecondsSinceEpoch) >
                0)
            .toList();
        final List<dynamic> doneGoals = myGoalsList
            .where((element) =>
                (element[8].toInt() - DateTime.now().millisecondsSinceEpoch) <
                0)
            .toList();
        final List<dynamic> inProgressCreated = myCreatedList
            .where((element) =>
                (element[8].toInt() - DateTime.now().millisecondsSinceEpoch) >
                0)
            .toList();
        final List<dynamic> doneCreated = myCreatedList
            .where((element) =>
                (element[8].toInt() - DateTime.now().millisecondsSinceEpoch) <
                0)
            .toList();
        print(myGoals);
        print(myGoalsList);
        print(inProgressGoals);
        print(doneGoals);

        final Widget goalsList;

        if (inProgressGoals.isEmpty) {
          goalsList = const Center(
            child: Text('No project found'),
          );
        } else {
          goalsList = SizedBox(
            height: 450,
            child: ListView.builder(
              itemCount: inProgressGoals.length,
              itemBuilder: (context, index) {
                return Column(children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(6),
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
                          index: inProgressGoals[index][0].toInt(),
                        ),
                      ],
                    ),
                  ),
                ]);
              },
            ),
          );
        }

        final Widget doneGoalsList;

        if (doneGoals.isEmpty) {
          doneGoalsList = const Center(
            child: Text('No project found'),
          );
        } else {
          doneGoalsList = SizedBox(
            height: 450,
            child: ListView.builder(
              itemCount: doneGoals.length,
              itemBuilder: (context, index) {
                return Column(children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(6),
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
                          index: doneGoals[index][0].toInt(),
                        ),
                      ],
                    ),
                  ),
                ]);
              },
            ),
          );
        }

        final Widget doneCreatedList;

        if (doneCreated.isEmpty) {
          doneCreatedList = const Center(
            child: Text('No project found'),
          );
        } else {
          doneCreatedList = SizedBox(
            height: 450,
            child: ListView.builder(
              itemCount: doneCreated.length,
              itemBuilder: (context, index) {
                return Column(children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(6),
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
                    child: CreatedCard(
                      index: doneCreated[index][0].toInt(),
                    ),
                  ),
                ]);
              },
            ),
          );
        }

        final Widget startCreatedList;

        if (inProgressCreated.isEmpty) {
          startCreatedList = const Center(
            child: Text('No project found'),
          );
        } else {
          startCreatedList = SizedBox(
            height: 450,
            child: ListView.builder(
              itemCount: inProgressCreated.length,
              itemBuilder: (context, index) {
                return Column(children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(6),
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
                    child: CreatedCard(
                      index: inProgressCreated[index][0].toInt(),
                    ),
                  ),
                ]);
              },
            ),
          );
        }

        final Widget createdGoalsList;

        createdGoalsList = Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const CreateScreen();
                    },
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Create Project',
                      style: TextStyle(
                          color: Color.fromARGB(255, 129, 129, 129),
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.add,
                        size: 35, color: Color.fromARGB(255, 129, 129, 129))
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
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
                          statusSelecionado2 = 'In progress';
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: statusSelecionado2 == 'In progress'
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "In progress",
                        style: TextStyle(
                            color: statusSelecionado2 == 'In progress'
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          statusSelecionado2 = 'Finished';
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: statusSelecionado2 == 'Finished'
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Finished",
                        style: TextStyle(
                            color: statusSelecionado2 == 'Finished'
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            statusSelecionado2 == 'In progress'
                ? startCreatedList
                : doneCreatedList,
          ],
        );

        return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          "Profile",
                          style: Theme.of(context).textTheme.titleLarge,
                        )),
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
                  ),
                  Stack(children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
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
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      width: 90,
                                    ),
                                    Column(
                                      children: [
                                        const Text("Projects"),
                                        Text(
                                          "${myGoals.length}",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Text("Wallet"),
                                        FutureBuilder(
                                          future: getInfos(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Text(
                                                "GC ",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              );
                                            } else if (snapshot.hasError) {
                                              return const Text(
                                                "GC ",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              );
                                            } else {
                                              return SizedBox(
                                                width: 90,
                                                child: Text(
                                                  balanceEth.toStringAsFixed(2),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          nameFinal,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text(emailFinal,
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        const SizedBox(height: 5),
                                        GestureDetector(
                                          onTap: () {
                                            FlutterClipboard.copy(address)
                                                .then((value) {
                                              const snackBar = SnackBar(
                                                content: Text(
                                                    'Copied to clipboard!'),
                                              );
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            });
                                          },
                                          child: Row(children: [
                                            Text(
                                                'Address: ${address.substring(0, 6)}...',
                                                style: const TextStyle(
                                                    fontSize: 12)),
                                            const SizedBox(width: 5),
                                            const Icon(Icons.copy, size: 15),
                                          ]),
                                        ),
                                      ],
                                    ),
                                    // IconButton(
                                    //   onPressed: () {},
                                    //   icon: SvgPicture.asset(
                                    //       'assets/icons/edit.svg',
                                    //       width: 27,
                                    //       height: 27),
                                    // )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Positioned(
                      top: 0,
                      left: 30,
                      child: BuildProfileAvatar(size: 50),
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
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
                                statusSelecionado = 'Active';
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: statusSelecionado == 'Active'
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Active",
                              style: TextStyle(
                                  color: statusSelecionado == 'Active'
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                statusSelecionado = 'Finished';
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: statusSelecionado == 'Finished'
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Finished",
                              style: TextStyle(
                                  color: statusSelecionado == 'Finished'
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                statusSelecionado = 'Created';
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: statusSelecionado == 'Created'
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Created",
                              style: TextStyle(
                                  color: statusSelecionado == 'Created'
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (statusSelecionado == 'Active')
                    goalsList
                  else if (statusSelecionado == 'Finished')
                    doneGoalsList
                  else
                    createdGoalsList,
                  const SizedBox(height: 90),
                ],
              ),
            )),
          ),
        );
      },
    );
  }
}

bool active = true;
