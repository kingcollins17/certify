import '../models/certificate.dart';
import '../models/certificate_group.dart';
import '../services/services.dart';
import 'certificate_repository.dart';

class LocalCertificateRepository implements CertificateRepository {
  static const _storageKey = 'certificates';

  final LocalStorageService _localStorage;

  LocalCertificateRepository(this._localStorage);

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
    final certs = _localStorage.get<List<dynamic>>(
      _storageKey,
      (data) => (data as List).cast<Map<String, dynamic>>(),
    );

    if (certs == null) return [];

    return certs.map((json) => Certificate.fromJson(json)).toList();
  }

  @override
  Future<Certificate?> getCertificateById(String id) async {
    final certificates = await getAllCertificates();
    return certificates.firstWhere((c) => c.id == id);
  }

  @override
  Future<List<CertificateGroup>> getCertificateGroups() async {
    final certificates = await getAllCertificates();

    // Group all certs by issuer name as default grouping
    final groupsMap = <String, List<Certificate>>{};

    for (var cert in certificates) {
      groupsMap.putIfAbsent(cert.issuer.name, () => []).add(cert);
    }

    return groupsMap.entries
        .map((e) => CertificateGroup(groupName: e.key, certificates: e.value))
        .toList();
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
    final serialized = certificates.map((c) => c.toJson()).toList();
    await _localStorage.save<List<Map<String, dynamic>>>(
      _storageKey,
      serialized,
      (list) => list,
    );
  }
}
