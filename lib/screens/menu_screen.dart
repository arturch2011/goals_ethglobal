import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goals_ethglobal/providers/user_info_provider.dart';
import 'package:goals_ethglobal/screens/wallet_screen.dart';
import 'package:goals_ethglobal/screens/buy_nouns.dart';

import 'package:provider/provider.dart';


//CRIAR UM BOTAO PRO CARA CCOMPRAR OS TOKENS

//puxar ele pra router de buy_nouns

class Menu extends StatelessWidget {
  const Menu({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove o botão de voltar
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/config.svg',
                  width: 27,
                ),
                label: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.black),
                ),
                style: const ButtonStyle(alignment: Alignment.centerLeft),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const Wallet();
                      },
                    ),
                  );
                },
                icon: SvgPicture.asset(
                  'assets/icons/wallet.svg',
                  width: 27,
                ),
                label: const Text(
                  'Deposit and withdraw',
                  style: TextStyle(color: Colors.black),
                ),
                style: const ButtonStyle(alignment: Alignment.centerLeft),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/heart.svg',
                  width: 27,
                ),
                label: const Text(
                  'Favorites',
                  style: TextStyle(color: Colors.black),
                ),
                style: const ButtonStyle(alignment: Alignment.centerLeft),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/help.svg',
                  width: 27,
                ),
                label: const Text(
                  'Help',
                  style: TextStyle(color: Colors.black),
                ),
                style: const ButtonStyle(alignment: Alignment.centerLeft),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/question.svg',
                  width: 27,
                ),
                label: const Text(
                  'Frequently asked',
                  style: TextStyle(color: Colors.black),
                ),
                style: const ButtonStyle(alignment: Alignment.centerLeft),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const BuyNouns();
                        }
                      ),
                    );
                },
                icon: Image.asset('assets/icons/head-saturn.png', width: 27),
                label: const Text(
                  'Buy Nouns',
                  style: TextStyle(color: Colors.black),
                ),
                style: const ButtonStyle(alignment: Alignment.centerLeft),
              ),
            ),
            const Spacer(), // Adiciona um espaço flexível entre os botões e o botão inferior
            TextButton.icon(
              onPressed: () {
                context.read<UserProvider>().logout();
                Navigator.of(context).pop();
              },
              icon: SvgPicture.asset(
                'assets/icons/logout.svg',
                width: 27,
              ),
              label: const Text(
                'Log out',
                textHeightBehavior: TextHeightBehavior(
                    applyHeightToFirstAscent: true,
                    applyHeightToLastDescent: false),
                style: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
