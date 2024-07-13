import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goals_ethglobal/providers/user_info_provider.dart';
import 'package:goals_ethglobal/utils/eth_utils.dart';
import 'package:goals_ethglobal/utils/pinata_utils.dart';
import 'package:goals_ethglobal/widgets/loading_popup.dart';
import 'package:provider/provider.dart' as prov;

class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;
  final int index;
  const ImagePreviewScreen(
      {super.key, required this.imagePath, required this.index});

  @override
  Widget build(BuildContext context) {
    final int dia = DateTime.now().day;
    final photoList = prov.Provider.of<UserProvider>(context);
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(ethUtilsProviders);
        final ethUtils = ref.watch(ethUtilsProviders.notifier);

        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ), // Espaço flexível (ocupa o espaço que sobra)
                  const Center(
                      child: Text(
                    "Validation",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  const SizedBox(
                    height: 30,
                  ),

                  ///
                  Container(
                    width: double.infinity,
                    height: 500, // Ocupa toda a largura da tela
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(20.0), // Borda arredondada
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover, // Preencher toda a área
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Column(
                    children: [
                      Center(
                          child: Text(
                        "Looks nice!",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(height: 8), // Espaço entre os textos
                      Center(
                          child: Text(
                        "To validate the photo, just click “Send”, if not, let's take another one…",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )),
                      //
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ), // Espaço flexível (ocupa o espaço que sobra
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            showLoadingDialog(context);

                            try {
                              String result = await pinFile(imagePath);

                              final String link =
                                  result.substring(8, result.length - 26);
                              await ethUtils.updateFrequency(
                                  BigInt.from(index), link);
                              photoList.removeItem(index);
                              photoList.addItem(PhotoDate(index, dia));
                              await photoList.savePhotoList();
                              hideLoadingDialog(context);
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              showCheckDialog(context, 'Success !');
                            } catch (e) {
                              hideLoadingDialog(context);
                              showErrorDialog(context, e.toString());
                            }
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    16.0), // Raio dos cantos
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor,
                            ),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                          child: const Text('Send',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 8), // Espaço entre os botões
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      16.0), // Raio dos cantos
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2)),
                            ),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                          child: Text('Back',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                        ),
                      ),
                    ],
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
