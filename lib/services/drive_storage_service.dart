import 'dart:io';

abstract interface class DriveStorageService {
  /// Uploads a file to Google Drive.
  /// Returns the file ID on success.
  Future<String> uploadFile({
    required File file,
    required String accessToken,
    String? fileName,
  });

  /// Fetches a list of files from the user's Google Drive.
  /// Returns a list of maps containing file metadata.
  Future<List<Map<String, dynamic>>> listFiles({required String accessToken});

  /// Makes a file public by updating its permissions.
  Future<void> makeFilePublic({
    required String fileId,
    required String accessToken,
  });

  /// Generates a download URL for a given file ID.
  /// Note: The file must be public or accessible via token.
  String generateDownloadLink(String fileId);
}
