import 'package:certify/services/services.dart';
import 'package:get/get.dart';
import 'controllers/controllers.dart';
import 'repositories/repositories.dart';

class CertifyBindings extends Bindings {
  @override
  void dependencies() {
    _injectRepositories();
    _injectControllers();
  }

  void _injectControllers() {
    Get.put(AuthControllerImpl(), permanent: true);
    Get.lazyPut(
      () => CertificateControllerImpl(Get.find<LocalCertificateRepository>()),
    );
  }

  void _injectRepositories() {
    Get.lazyPut(
      () => LocalCertificateRepository(
        HiveLocalStorageService('certificates'),
        HiveLocalStorageService('certificates-group'),
      ),
    );
  }
}
