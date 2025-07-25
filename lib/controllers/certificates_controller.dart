import 'package:certify/controllers/controllers.dart';
import 'package:certify/services/services.dart';
import 'package:certify/utils/utils.dart';
import 'package:get/get.dart';
import '../models/certificate.dart';
import '../models/certificate_group.dart';
import '../repositories/repositories.dart';

abstract interface class CertificateController {
  RxList<Certificate> get certificates;
  RxList<CertificateGroup> get certificateGroups;
  RxBool get isLoading;

  Future<void> loadCertificates();
  Future<void> loadCertificateGroups();
  Future<void> addCertificate(Certificate cert);
  Future<void> updateCertificate(Certificate cert);
  Future<void> deleteCertificate(String id);
  List<Certificate> getCertificatesByGroupId(String groupId);

  Future<String> uploadToDrive(Certificate certificate);
}

class CertificateControllerImpl extends GetxController
    implements CertificateController {
  final CertificateRepository _repository;

  CertificateControllerImpl(this._repository);

  final RxList<Certificate> _certificates = <Certificate>[].obs;
  final RxList<CertificateGroup> _groups = <CertificateGroup>[].obs;
  final RxBool _isLoading = false.obs;

  @override
  void onInit() {
    loadCertificates();
    loadCertificateGroups();
    super.onInit();
  }

  @override
  RxList<Certificate> get certificates => _certificates;

  @override
  RxList<CertificateGroup> get certificateGroups => _groups;

  @override
  RxBool get isLoading => _isLoading;

  @override
  Future<void> loadCertificates() async {
    try {
      _isLoading.value = true;
      final result = await _repository.getAllCertificates();
      _certificates.assignAll(result);
      HelperUtility().log('Certificates loaded');
    } catch (e) {
      HelperUtility().log(
        'Error failed to load cerificates, $e - ${e.runtimeType}',
      );
      if (e is Error) {
        HelperUtility().log(e.stackTrace.toString());
      }
      Get.snackbar('Error', 'Failed to load certificates');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> loadCertificateGroups() async {
    _isLoading.value = true;
    try {
      final result = await _repository.getCertificateGroups();
      _groups.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load certificate groups');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  List<Certificate> getCertificatesByGroupId(String groupId) {
    return _certificates.where((cert) => cert.groupId == groupId).toList();
  }

  @override
  Future<void> addCertificate(Certificate cert) async {
    _isLoading.value = true;
    try {
      await _repository.createCertificate(cert);
      await loadCertificates();
    } catch (e) {
      HelperUtility().log(e);
      if (e is Error) {
        HelperUtility().log(e.stackTrace.toString());
      }
      Get.snackbar('Error', 'Failed to add certificate');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> updateCertificate(Certificate cert) async {
    _isLoading.value = true;
    try {
      await _repository.updateCertificate(cert);
      await loadCertificates();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update certificate');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> deleteCertificate(String id) async {
    _isLoading.value = true;
    try {
      await _repository.deleteCertificate(id);
      await loadCertificates();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete certificate');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<String> uploadToDrive(Certificate certificate) async {
    try {
      _isLoading.value = true;
      final file = await certificate.generateQRCodeFile();
      final drive = GoogleDriveStorageService();
      final auth = Get.find<AuthControllerImpl>();

      if (!auth.isAuthenticated) {
        await auth.signInWithGoogle();
      }
      if (!auth.isAuthenticated) throw Exception('You are not signed in');

      String? token = auth.accessToken.value;
      if (token == null) {
        await auth.signInWithGoogle();
        token = auth.accessToken.value;
      }

      if (token == null) {
        throw Exception(
          'You need to be signed in with Google to upload to Drive',
        );
      }

      return await drive.uploadFile(file: file, accessToken: token);
    } catch (e) {
      HelperUtility().log(e);
      if (e is Error) {
        HelperUtility().log(e.stackTrace.toString());
      }
      Get.snackbar('Error', 'Failed to upload to Google Drive');
      rethrow; // in case you want the UI to handle it upstream too
    } finally {
      _isLoading.value = false;
    }
  }
}
