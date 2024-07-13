import 'package:flutter/material.dart';
import 'package:goals_ethglobal/providers/user_info_provider.dart';
import 'package:provider/provider.dart';

class BuildProfileAvatar extends StatelessWidget {
  final double size;
  const BuildProfileAvatar({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    String? urlImagem;
    String? name;
    try {
      urlImagem = context.watch<UserProvider>().userInfos[0]['userInfo']
          ["profileImage"];
      name = context.watch<UserProvider>().userInfos[0]['userInfo']["name"];
    } catch (e) {
      urlImagem = null;
      name = null;
    }

    final String nameFinal;

    name == null ? nameFinal = "Usuário" : nameFinal = name;
    // return Container(
    //   width: size,
    //   height: size,
    //   margin: const EdgeInsets.fromLTRB(0, 15, 15, 15),
    //   decoration: const BoxDecoration(
    //     shape: BoxShape.circle,
    //     color: Color.fromRGBO(189, 189, 189, 1),
    //   ),
    // );
    return CircleAvatar(
      radius: size,
      backgroundImage: urlImagem != null ? NetworkImage(urlImagem) : null,
      backgroundColor: Colors.grey[300],
      child: urlImagem == null
          ? Text(nameFinal.substring(0, 1).toUpperCase())
          : null,
    );
  }
}
