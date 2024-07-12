import 'dart:async';

import 'package:flutter/material.dart';
import 'package:goals_ethglobal/providers/user_info_provider.dart';
import 'package:goals_ethglobal/screens/home_screen.dart';
import 'package:goals_ethglobal/screens/login_screen.dart';
import 'package:goals_ethglobal/screens/profile_screen.dart';
import 'package:goals_ethglobal/screens/projects_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Outfit',
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(104, 80, 255, 1),
              primary: const Color.fromRGBO(104, 80, 255, 1),
              secondary: const Color.fromRGBO(61, 206, 252, 1)),
          scaffoldBackgroundColor: const Color.fromRGBO(250, 251, 253, 1),
          inputDecorationTheme: const InputDecorationTheme(
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            prefixIconColor: Color.fromRGBO(119, 119, 119, 1),
          ),
          textTheme: const TextTheme(
            titleMedium: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            bodySmall: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            titleLarge: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 30,
            ),
          ),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          useMaterial3: true,
        ),
        title: 'Goals App',
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> appInitializer() async {
    await context.read<UserProvider>().initPlatformState();

    final isLogged = context.read<UserProvider>().isLogged;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: appInitializer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                color: Colors.white,
                child: const Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final isLogged = context.watch<UserProvider>().isLogged;
            // Use isLogged here
            return isLogged ? const MysHomePage() : const LoginScreen();
          }
        });
  }
}

class MysHomePage extends StatefulWidget {
  const MysHomePage({super.key});

  @override
  State<MysHomePage> createState() => _MysHomePageState();
}

class _MysHomePageState extends State<MysHomePage> {
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (currentPage) {
      case 0:
        page = const ProjectsScreen();
        break;
      case 1:
        page = const HomeScreen();
        break;
      case 2:
        page = const ProfileScreen();
        break;
      default:
        throw UnimplementedError('no widget for $currentPage');
    }
    return Scaffold(
      body: Stack(
        children: [
          page,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                color: Colors.white, // Cor de fundo
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Sombra
                    spreadRadius: 2,
                    blurRadius: 5,
                    // Ajuste a sombra vertical aqui
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(
                  vertical: 15, horizontal: 20), // Margem superior
              padding: const EdgeInsets.symmetric(
                  vertical: 5, horizontal: 20), // Padding interno
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0, // Cor de fundo
                  iconSize: 20,

                  selectedFontSize: 0,
                  unselectedFontSize: 0,
                  enableFeedback: false,
                  onTap: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  currentIndex: currentPage,
                  items: [
                    BottomNavigationBarItem(
                      activeIcon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/paper.svg',
                          width: 27,
                          height: 27,
                          color: Colors.white,
                        ),
                      ),
                      icon: SvgPicture.asset('assets/icons/paper.svg',
                          width: 27, height: 27),
                      label: 'Projects',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/home.svg',
                          width: 27,
                          height: 27,
                          color: Colors.white,
                        ),
                      ),
                      icon: SvgPicture.asset('assets/icons/home.svg',
                          width: 27, height: 27),
                      label: 'Home',
                    ),
                    // BottomNavigationBarItem(
                    //   activeIcon: Container(
                    //     padding: const EdgeInsets.all(12),
                    //     decoration: const BoxDecoration(
                    //       color: Color.fromRGBO(217, 217, 217, 1),
                    //       borderRadius: BorderRadius.all(
                    //         Radius.circular(50),
                    //       ),
                    //     ),
                    //     child: const Icon(Icons.camera_alt_outlined, size: 30, color: Color.fromARGB(255, 68, 68, 68)),
                    //   ),
                    //   icon: const Icon(Icons.camera_alt_outlined, size: 30, color: Color.fromARGB(255, 68, 68, 68)),
                    //   label: 'Camera',
                    // ),
                    BottomNavigationBarItem(
                      activeIcon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/user.svg',
                          width: 27,
                          height: 27,
                          color: Colors.white,
                        ),
                      ),
                      icon: SvgPicture.asset('assets/icons/user.svg',
                          width: 27, height: 27),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
