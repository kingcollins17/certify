import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/drive.file', // only files the app created
    // OR use: 'https://www.googleapis.com/auth/drive' for full access
  ],
);

// final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
// final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

/// access token to use for api calls
// final accessToken = googleAuth.accessToken;

Future<void> uploadToDrive(String filePath, String accessToken) async {
  final fileBytes = await File(filePath).readAsBytes();

  final response = await http.post(
    Uri.parse(
      'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart',
    ),
    headers: {
      'Authorization': 'Bearer $accessToken', // 👈 Don't forget this!
      'Content-Type': 'multipart/related; boundary=foo_bar_baz',
    },
    body: '''
--foo_bar_baz
Content-Type: application/json; charset=UTF-8

{
  "name": "my_uploaded_file.txt"
}

--foo_bar_baz
Content-Type: text/plain

${String.fromCharCodes(fileBytes)}
--foo_bar_baz--
''',
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final fileId = responseData['id'];

    print("✅ Upload successful! File ID: $fileId");

    // Optional: create the download URL
    final downloadUrl =
        'https://www.googleapis.com/drive/v3/files/$fileId?alt=media';
    print("🔗 Download URL (auth needed unless made public): $downloadUrl");
  } else {
    print("❌ Upload failed: ${response.body}");
  }
}

Future<void> listMyDriveFiles(String accessToken) async {
  final response = await http.get(
    Uri.parse('https://www.googleapis.com/drive/v3/files'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final files = jsonData['files'];

    for (var file in files) {
      print('📄 ${file['name']} - 🆔 ${file['id']}');
    }
  } else {
    print('❌ Failed to list files: ${response.body}');
  }
}

Future<void> makeFilePublic(String fileId, String accessToken) async {
  final response = await http.post(
    Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId/permissions'),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'role': 'reader', 'type': 'anyone'}),
  );

  if (response.statusCode == 200) {
    print('✅ File is now publicly accessible.');
  } else {
    print('❌ Failed to update permissions: ${response.body}');
  }
}

String generateDownloadLink() =>
    'https://www.googleapis.com/drive/v3/files/<FILE_ID>?alt=media';
