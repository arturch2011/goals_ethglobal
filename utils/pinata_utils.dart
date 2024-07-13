import 'dart:io';

import 'package:pinata/pinata.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String> pinFile(String filename) async {
  String apiKey = dotenv.env['PINATA_API_KEY']!;
  String secret = dotenv.env['PINATA_SECRET']!;
  var pinata = Pinata.viaPair(apiKey: apiKey, secret: secret);

  final Iterable<Pin> pin;
  pinata = Pinata.test;
  print("PINATAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
  final result = await pinata.pinFile(File(filename));
  pin = await pinata.pins;
  // "PinLink(https://gateway.pinata.cloud/ipfs/bafkreiemp4fn42nel7umssajgrg6ishnrqskujxnyopltvhgurv47a5h4e,2024-02-26T06:30:18.379Z)"  comeca 7 retira - 26

  return result.toString();
}
