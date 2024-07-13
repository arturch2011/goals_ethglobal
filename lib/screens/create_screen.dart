import 'package:flutter/material.dart';
import 'package:goals_ethglobal/utils/eth_utils.dart';
import 'package:goals_ethglobal/utils/pinata_utils.dart';
import 'package:goals_ethglobal/widgets/loading_popup.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  String nome = '';
  String descricao = '';
  String categoriaSelecionada = categorias[0];
  String frequenciaSelecionada = frequencias[0];
  int vezes = 1;
  int meta = 1;
  int duration = 1;
  int totalMeta = 1;
  String tipoValorAcrescido = tiposValorAcrescido[0];
  double aposta = 0;
  double preFund = 0;

  int numeroPessoas = 100000;
  DateTime dataInicial =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(const Duration(days: 1));
  DateTime dataFinal =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(const Duration(days: 2));

  bool isPublico = true;
  final picker = ImagePicker();
  XFile? pickedImage;
  List<String> imgList = [];

  @override
  Widget build(BuildContext context) {
    final int startTime = dataInicial.millisecondsSinceEpoch;
    final int endTime = dataFinal.millisecondsSinceEpoch;

    final int totalDays = (endTime - startTime) / (1000 * 60 * 60 * 24) > 0
        ? (endTime - startTime) ~/ (1000 * 60 * 60 * 24)
        : 0;
    final int totalWeeks = (endTime - startTime) / (1000 * 60 * 60 * 24 * 7) > 0
        ? (endTime - startTime) ~/ (1000 * 60 * 60 * 24 * 7)
        : 0;
    final int totalMonths =
        (endTime - startTime) / (1000 * 60 * 60 * 24 * 30) > 0
            ? (endTime - startTime) ~/ (1000 * 60 * 60 * 24 * 30)
            : 0;

    if (frequenciaSelecionada == 'Daily') {
      totalMeta = totalDays;
    } else if (frequenciaSelecionada == 'Weekly') {
      totalMeta = totalWeeks * vezes;
      duration = 8;
    } else if (frequenciaSelecionada == 'Monthly') {
      totalMeta = totalMonths * vezes;
      duration = 31;
    } else {
      totalMeta = 1;
    }

    return Consumer(
      builder: (context, ref, child) {
        ref.watch(ethUtilsProviders);
        final ethUtils = ref.watch(ethUtilsProviders.notifier);

        // Use the myProvider here
        return Scaffold(
          appBar: AppBar(
            title: const Text('New Project'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Name'),
                  const SizedBox(height: 6),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        nome = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Name', // Placeholder
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6), // Espaçamento interno
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(16.0), // Borda arredondada
                        borderSide: const BorderSide(
                            color: Colors.grey), // Cor da borda padrão
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(16.0), // Borda arredondada
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .primary), // Cor da borda quando em foco
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Category'),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categorias.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              categoriaSelecionada = categorias[index];
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: categoriaSelecionada == categorias[index]
                                  ? Colors.black
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Center(
                                child: Text(
                              categorias[index],
                              style: TextStyle(
                                color: categoriaSelecionada == categorias[index]
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            )),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Frequency'),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: frequencias.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              frequenciaSelecionada = frequencias[index];
                              if (frequenciaSelecionada == 'Daily') {
                                vezes = 1;
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: frequenciaSelecionada == frequencias[index]
                                  ? Colors.black
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Center(
                                child: Text(
                              frequencias[index],
                              style: TextStyle(
                                color:
                                    frequenciaSelecionada == frequencias[index]
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            )),
                          ),
                        );
                      },
                    ),
                  ),
                  frequenciaSelecionada == 'Weekly' ||
                          frequenciaSelecionada == 'Monthly'
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text('How many times ?'),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          setState(() {
                                            if (vezes > 1) {
                                              vezes--;
                                            }
                                          });
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      16.0), // Raio dos cantos
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            const Color.fromRGBO(
                                                217, 217, 217, 1),
                                          ),
                                        )),
                                    const SizedBox(width: 10),
                                    Text('$vezes'),
                                    const SizedBox(width: 10),
                                    IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            vezes++;
                                          });
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      16.0), // Raio dos cantos
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            const Color.fromRGBO(
                                                217, 217, 217, 1),
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox(),

                  const SizedBox(height: 20),
                  const Text('Meta'),
                  Row(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (meta > 1) {
                                    meta--;
                                  }
                                });
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
                                  const Color.fromRGBO(217, 217, 217, 1),
                                ),
                              )),
                          const SizedBox(width: 10),
                          Text(meta.toString()),
                          const SizedBox(width: 10),
                          IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  meta++;
                                });
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
                                  const Color.fromRGBO(217, 217, 217, 1),
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: const Color.fromRGBO(217, 217, 217, 1),
                        ),
                        child: DropdownButton<String>(
                          value: tipoValorAcrescido,
                          onChanged: (value) {
                            setState(() {
                              tipoValorAcrescido = value!;
                            });
                          },
                          items: tiposValorAcrescido.map((String tipo) {
                            return DropdownMenuItem<String>(
                              value: tipo,
                              child: Text(tipo),
                            );
                          }).toList(),
                          borderRadius: BorderRadius.circular(16.0),
                          dropdownColor: const Color.fromRGBO(217, 217, 217, 1),
                          isDense: true,
                          enableFeedback: true,
                          menuMaxHeight: 200,
                          underline: Container(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Minimum bet (optional)'),
                  const SizedBox(height: 6),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        aposta = double.tryParse(value) ?? 0;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Bet Value', // Placeholder
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6), // Espaçamento interno
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(16.0), // Borda arredondada
                        borderSide: const BorderSide(
                            color: Colors.grey), // Cor da borda padrão
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(16.0), // Borda arredondada
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .primary), // Cor da borda quando em foco
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Initial Prize (optional)'),
                  const SizedBox(height: 6),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        preFund = double.tryParse(value) ?? 0;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Initial Prize Value', // Placeholder
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6), // Espaçamento interno
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(16.0), // Borda arredondada
                        borderSide: const BorderSide(
                            color: Colors.grey), // Cor da borda padrão
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(16.0), // Borda arredondada
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .primary), // Cor da borda quando em foco
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Participants Limit'),
                  Row(
                    children: [
                      IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (numeroPessoas == 1 ||
                                  numeroPessoas >= 100000) {
                                numeroPessoas = 100000;
                              } else if (numeroPessoas > 1) {
                                numeroPessoas--;
                              }
                            });
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
                              const Color.fromRGBO(217, 217, 217, 1),
                            ),
                          )),
                      const SizedBox(width: 10),
                      GestureDetector(
                          onTap: () {
                            // Abrir o diálogo para selecionar o número de pessoas
                            _showPicker(context);
                          },
                          child: Text(numeroPessoas >= 100000
                              ? "∞"
                              : numeroPessoas.toString())),
                      const SizedBox(width: 10),
                      IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              if (numeroPessoas >= 100000) {
                                numeroPessoas = 1;
                              } else {
                                numeroPessoas++;
                              }
                            });
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
                              const Color.fromRGBO(217, 217, 217, 1),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Period'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('By:'),
                            TextFormField(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: dataInicial,
                                  firstDate: dataInicial,
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null &&
                                    pickedDate != dataInicial) {
                                  setState(() {
                                    dataInicial = pickedDate;
                                  });
                                }
                              },
                              controller: TextEditingController(
                                  text:
                                      "${dataInicial.toLocal()}".split(' ')[0]),
                              readOnly: true,
                              decoration: InputDecoration(
                                // Placeholder
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6), // Espaçamento interno
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      16.0), // Borda arredondada
                                  borderSide: const BorderSide(
                                      color:
                                          Colors.grey), // Cor da borda padrão
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      16.0), // Borda arredondada
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary), // Cor da borda quando em foco
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('To:'),
                            TextFormField(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      dataInicial.add(Duration(days: duration)),
                                  firstDate:
                                      dataInicial.add(Duration(days: duration)),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null &&
                                    pickedDate != dataFinal) {
                                  setState(() {
                                    dataFinal = pickedDate;
                                  });
                                }
                              },
                              controller: TextEditingController(
                                  text: "${dataFinal.toLocal()}".split(' ')[0]),
                              readOnly: true,
                              decoration: InputDecoration(
                                // Placeholder
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6), // Espaçamento interno
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      16.0), // Borda arredondada
                                  borderSide: const BorderSide(
                                      color:
                                          Colors.grey), // Cor da borda padrão
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      16.0), // Borda arredondada
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary), // Cor da borda quando em foco
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('How can see'),
                  SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isPublico = true;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isPublico ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Center(
                                child: Text(
                              "Public",
                              style: TextStyle(
                                color: isPublico ? Colors.white : Colors.black,
                              ),
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isPublico = false;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: !isPublico ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Center(
                                child: Text(
                              "Private",
                              style: TextStyle(
                                color: !isPublico ? Colors.white : Colors.black,
                              ),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Project Cover'),
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: () async {
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);

                      if (pickedFile != null) {
                        setState(() {
                          pickedImage = pickedFile;
                        });
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16.0), // Raio dos cantos
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor,
                      ),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(16),
                      ),
                    ),
                    child: const Text('Pick from gallery',
                        style: TextStyle(color: Colors.white)),
                  ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     final pickedFile =
                  //         await picker.pickImage(source: ImageSource.gallery);

                  //     if (pickedFile != null) {
                  //       setState(() {
                  //         pickedImage = pickedFile;
                  //       });
                  //     }
                  //   },
                  //   child: const Text('Selecionar da galeria'),
                  // ),
                  const SizedBox(height: 6),
                  pickedImage != null
                      ? Container(
                          width: double.infinity,
                          height: 400, // Ocupa toda a largura da tela
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                20.0), // Borda arredondada
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.file(
                              File(pickedImage!.path),
                              fit: BoxFit.cover, // Preencher toda a área
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 20),
                  const Text('Description'),
                  const SizedBox(height: 6),
                  TextFormField(
                    minLines: 3,
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        descricao = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Your description here...',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        showLoadingDialog(context);
                        // try {
                        BigInt metaBigInt = BigInt.from(meta);
                        BigInt totalMetaBigInt = BigInt.from(totalMeta);
                        BigInt vezesBigInt = BigInt.from(vezes);
                        // BigInt preFundBigInt = BigInt.from(preFund);
                        // BigInt apostaBigInt = BigInt.from(aposta);
                        BigInt dataInicialBigInt =
                            BigInt.from(dataInicial.millisecondsSinceEpoch);
                        BigInt dataFinalBigInt =
                            BigInt.from(dataFinal.millisecondsSinceEpoch);
                        BigInt numeroPessoasBigInt = BigInt.from(numeroPessoas);
                        String result = await pinFile(pickedImage!.path);
                        print("RESULTADOOOOOOOOOOOOOOOOOOOO");
                        print(result);
                        final String link =
                            result.substring(8, result.length - 26);
                        print(totalMeta);
                        print("Linkkkkkkkkkkkkkkkkkkkk");
                        print(link);
                        imgList.add(link);

                        await ethUtils.createGoal(
                            nome,
                            descricao,
                            categoriaSelecionada,
                            frequenciaSelecionada,
                            totalMetaBigInt,
                            aposta,
                            dataInicialBigInt,
                            dataFinalBigInt,
                            isPublico,
                            preFund,
                            numeroPessoasBigInt,
                            imgList,
                            tipoValorAcrescido,
                            vezesBigInt,
                            metaBigInt);
                        hideLoadingDialog(context);
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        showCheckDialog(context, 'Created with success !');
                        // } catch (e) {
                        //   hideLoadingDialog(context);
                        //   showErrorDialog(context, e.toString());
                        // }
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16.0), // Raio dos cantos
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor,
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                      child: const Text('Create Project',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select the limit of participants'),
        content: SizedBox(
          height: 100,
          child: TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(() {
              if (value == "") {
                numeroPessoas = 100000;
              } else {
                numeroPessoas = int.parse(value);
              }
            }),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

List<String> categorias = ['Exercise', 'Routine', 'Reading', 'Studies'];
List<String> frequencias = ['Daily', 'Weekly', 'Monthly'];
List<String> tiposValorAcrescido = [
  'Liters',
  'Km',
  'Repetitions',
  "Minuts",
  "Hours"
];
