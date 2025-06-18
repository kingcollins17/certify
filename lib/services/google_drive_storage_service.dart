import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'drive_storage_service.dart';

class GoogleDriveStorageService implements DriveStorageService {
  @override
  Future<String> uploadFile({
    required File file,
    required String accessToken,
    String? fileName,
  }) async {
    final fileBytes = await file.readAsBytes();
    final name = fileName ?? file.path.split('/').last;

    final uri = Uri.parse(
      'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart',
    );

    final request =
        http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $accessToken'
          ..fields['name'] = name
          ..files.add(
            http.MultipartFile.fromBytes('file', fileBytes, filename: name),
          );

    final streamedResponse = await request.send();

    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final fileId = responseData['id'];
      return fileId;
    } else {
      throw Exception('Upload failed: ${response.body}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> listFiles({
    required String accessToken,
  }) async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/drive/v3/files'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['files']);
    } else {
      throw Exception('Failed to list files: ${response.body}');
    }
  }

  @override
  Future<void> makeFilePublic({
    required String fileId,
    required String accessToken,
  }) async {
    final response = await http.post(
      Uri.parse(
        'https://www.googleapis.com/drive/v3/files/$fileId/permissions',
      ),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'role': 'reader', 'type': 'anyone'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update file permissions: ${response.body}');
    }
  }

  @override
  String generateDownloadLink(String fileId) {
    return 'https://www.googleapis.com/drive/v3/files/$fileId?alt=media';
  }
}
