import 'package:certify/utils/utils.dart';

import '../models/certificate.dart';
import '../models/certificate_group.dart';
import '../services/services.dart';
import 'certificate_repository.dart';

class LocalCertificateRepository implements CertificateRepository {
  // static const _storageKey = 'certificates';

  final LocalStorageService _certificatesStorage;

  final LocalStorageService _certificatesGroupStorage;

  LocalCertificateRepository(
    this._certificatesStorage,
    this._certificatesGroupStorage,
  );

  @override
  Future<void> createCertificate(Certificate certificate) async {
    final certificates = await getAllCertificates();
    certificates.add(certificate);
    await _saveAll(certificates);
  }

  @override
  Future<void> deleteCertificate(String id) async {
    final certificates = await getAllCertificates();
    certificates.removeWhere((c) => c.id == id);
    await _saveAll(certificates);
  }

  @override
  Future<List<Certificate>> getAllCertificates() async {
    final certs = await _certificatesStorage.getAll<Certificate>(
      (json) => Certificate.fromJson(json),
    );
    return certs;
  }

  @override
  Future<Certificate?> getCertificateById(String id) async {
    final certificates = await getAllCertificates();
    return certificates.firstWhere((c) => c.id == id);
  }

  @override
  Future<List<CertificateGroup>> getCertificateGroups() async {
    return _certificatesGroupStorage.getAll<CertificateGroup>(
      (i) => CertificateGroup.fromJson(i),
    );
  }

  @override
  Future<List<CertificateGroup>> groupCertificatesByIssuer() async {
    // Same as getCertificateGroups, but you can change grouping logic here if needed
    return getCertificateGroups();
  }

  @override
  Future<void> updateCertificate(Certificate certificate) async {
    final certificates = await getAllCertificates();

    final index = certificates.indexWhere((c) => c.id == certificate.id);
    if (index == -1) {
      throw Exception('Certificate with id ${certificate.id} not found');
    }
    certificates[index] = certificate;
    await _saveAll(certificates);
  }

  Future<void> _saveAll(List<Certificate> certificates) async {
    for (var cert in certificates) {
      await _certificatesStorage.save<Certificate>(
        cert.id,
        cert,
        (item) => item.toJson(),
      );
    }
  }
}
