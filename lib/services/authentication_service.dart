import 'package:certify/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract interface class AuthenticationService {
  /// Signs in using email and password.
  Future<Account> signInEmailAndPassword({
    required String email,
    required String password,
  });

  /// Signs in using Google Sign-In.
  Future<Account> signInWithGoogle();

  /// Stream that emits whenever the current user changes (login/logout).
  Stream<User?> get userStream;

  static final _instance = AuthenticationServiceImpl();

  factory AuthenticationService() => _instance;
}

class AuthenticationServiceImpl implements AuthenticationService {
  final FirebaseAuth _firebase = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/drive.file'],
  );

  /// Exposes Firebase's onAuthStateChanged stream.
  @override
  Stream<User?> get userStream => _firebase.authStateChanges();

  @override
  Future<Account> signInEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebase.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _getAccount(credential);
  }

  @override
  Future<Account> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }

    final auth = await googleUser.authentication;
    final credentials = _getCredential(auth);
    final cred = await _firebase.signInWithCredential(credentials);
    return _getAccount(cred, accessToken: auth.accessToken);
  }

  AuthCredential _getCredential(GoogleSignInAuthentication auth) {
    return GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
  }

  Account _getAccount(UserCredential credential, {String? accessToken}) {
    final user = credential.user;
    if (user == null) throw Exception('Unable to get a user account');
    return AccountModel(
      name: user.displayName ?? user.email ?? 'Unknown',
      email: user.email!,
      accessToken: accessToken,
    );
  }
}
