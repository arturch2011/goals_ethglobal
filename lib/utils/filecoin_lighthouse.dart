import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<http.Response> uploadFile(String filePath) async {
  String apiKey = dotenv.env['FILECOIN_LIGHTHOUSE_API_KEY']!;
  const String url = 'https://node.lighthouse.storage/api/v0/add';
  var request = http.MultipartRequest('POST', Uri.parse(url))
    ..headers['Authorization'] = 'Bearer $apiKey'
    ..files.add(await http.MultipartFile.fromPath(
      'file',
      filePath,
      filename: basename(filePath),
    ));

  var streamedResponse = await request.send();
  return await http.Response.fromStream(streamedResponse);
}

Future<Map<String, dynamic>> fetchFileInfo(String hash) async {
  final url =
      'https://api.lighthouse.storage/api/lighthouse/file_info?cid=$hash';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load file info');
  }
}

Future<Map<String, dynamic>> listUploadedFiles(String url) async {
  String apiKey = dotenv.env['FILECOIN_LIGHTHOUSE_API_KEY']!;
  const url =
      'https://api.lighthouse.storage/api/user/files_uploaded?lastKey=null';
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $apiKey',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load files');
  }
}
