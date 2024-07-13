import 'package:flutter/material.dart';
import 'package:goals_ethglobal/providers/user_info_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/login_image.jpg"), // Substitua 'imagem.jpg' pela imagem desejada.
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Entre na sua conta",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.read<UserProvider>().loginGoogle();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/google.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Google',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.read<UserProvider>().loginFacebook();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/facebook.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Facebook',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.read<UserProvider>().loginTwitter();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.grey,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/twitter.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'X',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Row(
                  //   children: <Widget>[
                  //     Expanded(
                  //       child: Container(
                  //         height: 1,
                  //         color: Colors.grey,
                  //       ),
                  //     ),
                  //     const Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 15.0),
                  //       child: Text(
                  //         "ou",
                  //         textHeightBehavior: TextHeightBehavior(
                  //             applyHeightToFirstAscent: false,
                  //             applyHeightToLastDescent: true),
                  //         style: TextStyle(
                  //           color: Colors.grey,
                  //           fontSize: 25,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Container(
                  //         height: 1,
                  //         color: Colors.grey,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
                  // const Text('E-mail or Phone'),
                  // const SizedBox(height: 6),
                  // TextFormField(
                  //   onChanged: (value) {},
                  //   decoration: InputDecoration(
                  //     hintText: 'E.g.: +(00)123456/name@example.com',
                  //     hintStyle: const TextStyle(
                  //       color: Colors.grey,
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w400,
                  //     ), // Placeholder
                  //     contentPadding: const EdgeInsets.symmetric(
                  //         horizontal: 16, vertical: 6), // Espaçamento interno
                  //     border: OutlineInputBorder(
                  //       borderRadius:
                  //           BorderRadius.circular(16.0), // Borda arredondada
                  //       borderSide: const BorderSide(
                  //           color: Colors.grey), // Cor da borda padrão
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius:
                  //           BorderRadius.circular(16.0), // Borda arredondada
                  //       borderSide: BorderSide(
                  //           color: Theme.of(context)
                  //               .colorScheme
                  //               .primary), // Cor da borda quando em foco
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       // Coloque aqui o código para processar o formulário
                  //     },
                  //     style: ButtonStyle(
                  //       shape:
                  //           MaterialStateProperty.all<RoundedRectangleBorder>(
                  //         RoundedRectangleBorder(
                  //           borderRadius:
                  //               BorderRadius.circular(16.0), // Raio dos cantos
                  //         ),
                  //       ),
                  //       backgroundColor: MaterialStateProperty.all(
                  //         Theme.of(context).primaryColor,
                  //       ),
                  //       padding: MaterialStateProperty.all(
                  //         const EdgeInsets.symmetric(vertical: 10),
                  //       ),
                  //     ),
                  //     child: const Text('Entrar',
                  //         style: TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 20)),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
