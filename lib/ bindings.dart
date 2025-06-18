import 'package:certify/controllers/auth_controller.dart';
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
  }

  void _injectRepositories() {}
}
