import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goals_ethglobal/providers/user_info_provider.dart';

import 'package:provider/provider.dart';

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
                  'Configurações e privacidade',
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
                  'assets/icons/wallet.svg',
                  width: 27,
                ),
                label: const Text(
                  'Depositar e resgatar',
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
                  'Favoritos',
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
                  'Ajuda',
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
                  'Perguntas frequentes',
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
                'Sair',
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
