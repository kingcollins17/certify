import '../models/certificate.dart';
import '../models/certificate_group.dart';

abstract interface class CertificateRepository {
  /// Get all certificates from the data source
  Future<List<Certificate>> getAllCertificates();

  /// Get a single certificate by ID or unique identifier
  Future<Certificate?> getCertificateById(String id);

  /// Create or issue a new certificate
  Future<void> createCertificate(Certificate certificate);

  /// Update an existing certificate
  Future<void> updateCertificate(Certificate certificate);

  /// Delete a certificate by ID
  Future<void> deleteCertificate(String id);

  /// Get all certificate groups (optional use case)
  Future<List<CertificateGroup>> getCertificateGroups();

  /// Group certificates by a custom logic (e.g., by issuer or owner)
  Future<List<CertificateGroup>> groupCertificatesByIssuer();

  /// Add a new certificate group
  Future<void> addCertificateGroup(CertificateGroup group);
}
