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

  RxString get searchQuery;
  RxnString get selectedGroupId;
  RxString get selectedFilter;

  void setSearchQuery(String query);
  void setSelectedGroupId(String? groupId);
  void setSelectedFilter(String filter);

  List<Certificate> get filteredCertificates;

  Future<void> loadCertificates();
  Future<void> loadCertificateGroups();
  Future<void> addCertificate(Certificate cert);
  Future<void> updateCertificate(Certificate cert);
  Future<void> deleteCertificate(String id);
  List<Certificate> getCertificatesByGroupId(String groupId);
  Future<String> uploadToDrive(Certificate certificate);
  Future<void> addCertificateGroup(CertificateGroup group);
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

  final RxString _searchQuery = ''.obs;
  final RxnString _selectedGroupId = RxnString();
  final RxString _selectedFilter = 'All'.obs;

  @override
  RxString get searchQuery => _searchQuery;

  @override
  RxnString get selectedGroupId => _selectedGroupId;

  @override
  RxString get selectedFilter => _selectedFilter;

  @override
  void setSearchQuery(String query) {
    _searchQuery.value = query.toLowerCase();
  }

  @override
  void setSelectedGroupId(String? groupId) {
    _selectedGroupId.value = groupId;
  }

  @override
  void setSelectedFilter(String filter) {
    _selectedFilter.value = filter;
  }

  @override
  List<Certificate> get filteredCertificates {
    List<Certificate> certs =
        _selectedGroupId.value != null
            ? getCertificatesByGroupId(_selectedGroupId.value!)
            : _certificates;

    if (_searchQuery.isNotEmpty) {
      certs =
          certs.where((cert) {
            return cert.title.toLowerCase().contains(_searchQuery.value) ||
                cert.owner.name.toLowerCase().contains(_searchQuery.value) ||
                cert.issuer.name.toLowerCase().contains(_searchQuery.value);
          }).toList();
    }

    if (_selectedFilter.value != 'All') {
      certs =
          certs.where((cert) {
            switch (_selectedFilter.value) {
              case 'Verified':
                return cert.fileUrl != null;
              case 'Pending':
                return cert.fileUrl == null;
              case 'Expired':
                return DateTime.now().difference(cert.issuedAt).inDays > 730;
              default:
                return true;
            }
          }).toList();
    }

    return certs;
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

  @override
  Future<void> addCertificateGroup(CertificateGroup group) async {
    _isLoading.value = true;
    try {
      await _repository.addCertificateGroup(group);
      await loadCertificateGroups();
      HelperUtility().log('Certificate group added successfully');
    } catch (e) {
      HelperUtility().log('Error adding group: $e');
      if (e is Error) {
        HelperUtility().log(e.stackTrace.toString());
      }
      Get.snackbar('Error', 'Failed to add certificate group');
    } finally {
      _isLoading.value = false;
    }
  }
}
