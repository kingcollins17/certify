import 'package:get/get.dart';
import 'ui/screens/screens.dart';

class CertifyRoutes {
  static List<GetPage> getRoutes() {
    return [
      GetPage(name: '/', page: () => HomeScreen()),
      GetPage(name: '/sign-in', page: () => SignInScreen()),
      GetPage(name: '/sign-up', page: () => SignUpScreen()),
    ];
  }
}
