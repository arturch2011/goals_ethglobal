import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


// to view image prefix is 'https://gateway.lighthouse.storage/ipfs/$hash'

void examples() async {
  // // UPLOAD METHOD
  // const String filePath = 'assets/example.png';
  // const String apiUrl = 'https://node.lighthouse.storage/api/v0/add';
  // // Upload method
  // final response = await uploadFile(filePath, apiUrl);
  // // Response example: {Name: example.png, Hash: bafkreigwbtlk52jy72yswygk67tpk2l2kqvkp2bvdmi3s7l5lkgovysfja, Size: 52495}
  // print(jsonDecode(response.body));

  // // GET INFO METHOD
  // final hash = 'bafkreigwbtlk52jy72yswygk67tpk2l2kqvkp2bvdmi3s7l5lkgovysfja';
  // final fileInfo = await fetchFileInfo(hash);
  // // Response example: {fileSizeInBytes: 52495, cid: bafkreigwbtlk52jy72yswygk67tpk2l2kqvkp2bvdmi3s7l5lkgovysfja, encryption: false, fileName: example.png, mimeType: image/png}
  // print(fileInfo);

  // // LIST FILES METHOD
  // final filesList = await listUploadedFiles();
  // // Response example:
  // // {
  // //   fileList: 
  // //     [
  // //       {
  // //         sentForDeal: no, 
  // //         publicKey: 0x1fedd6ad0bd44e8ac61403106bd09c6d860638f6, 
  // //         fileName: example.png, 
  // //         mimeType: image/png, 
  // //         createdAt: 1720887423516, 
  // //         fileSizeInBytes: 52495, 
  // //         cid: bafkreigwbtlk52jy72yswygk67tpk2l2kqvkp2bvdmi3s7l5lkgovysfja, 
  // //         id: b2308fa2-fc23-4e78-ab0b-5c3254bb00d9, 
  // //         lastUpdate: 1720887423516, 
  // //         encryption: false
  // //       }, 
  // //     ], 
  // //   totalFiles: 1
  // // }
  // print(filesList);
}

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
  final url = 'https://api.lighthouse.storage/api/lighthouse/file_info?cid=$hash';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load file info');
  }
}

Future<Map<String, dynamic>> listUploadedFiles(String url) async {
  String apiKey = dotenv.env['FILECOIN_LIGHTHOUSE_API_KEY']!;
  const url = 'https://api.lighthouse.storage/api/user/files_uploaded?lastKey=null';
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
