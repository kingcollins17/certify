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
}

class CertificateControllerImpl extends GetxController
    implements CertificateController {
  final CertificateRepository _repository;

  CertificateControllerImpl(this._repository);

  final RxList<Certificate> _certificates = <Certificate>[].obs;
  final RxList<CertificateGroup> _groups = <CertificateGroup>[].obs;
  final RxBool _isLoading = false.obs;

  @override
  RxList<Certificate> get certificates => _certificates;

  @override
  RxList<CertificateGroup> get certificateGroups => _groups;

  @override
  RxBool get isLoading => _isLoading;

  @override
  Future<void> loadCertificates() async {
    _isLoading.value = true;
    try {
      final result = await _repository.getAllCertificates();
      _certificates.assignAll(result);
    } catch (e) {
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
  Future<void> addCertificate(Certificate cert) async {
    _isLoading.value = true;
    try {
      await _repository.createCertificate(cert);
      await loadCertificates();
    } catch (e) {
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
}
