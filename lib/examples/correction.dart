import 'dart:async';

class AuthService {
  final _completer = Completer<dynamic>();

  Future whenSignInReady() async {
    return _completer.future;
  }

  Future signIn(String email, String password) async {
    await Future.delayed(Duration(seconds: 2));
    _completer.future;
    return true;
  }
}

void main() {
  // AuthService().signIn('collins@gmail.com', 'Password');
  // AuthService().whenSignInReady().then((_) {});
}
