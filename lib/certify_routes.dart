import 'package:get/get.dart';
import 'ui/screens/screens.dart';

class CertifyRoutes {
  static const String home = '/';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static List<GetPage> getRoutes() {
    return [
      GetPage(name: home, page: () => HomeScreen()),
      GetPage(name: signIn, page: () => SignInScreen()),
      GetPage(name: signUp, page: () => SignUpScreen()),
    ];
  }
}
