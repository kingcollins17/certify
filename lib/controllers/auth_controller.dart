import 'package:get/get.dart';
import 'package:certify/models/models.dart';
import 'package:certify/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthController {
  Rxn<Account> get account;
  RxnString get accessToken;
  RxBool get isLoading;

  bool get isAuthenticated;

  Future<void> signInWithEmail(String email, String password);

  Future<void> signUpWithEmail(String email, String password);
  Future<void> signInWithGoogle();
}

class AuthControllerImpl extends GetxController implements AuthController {
  final AuthenticationService _authService = AuthenticationService();

  final Rxn<Account> _account = Rxn<Account>();
  final RxnString _accessToken = RxnString();
  final RxBool _isLoading = false.obs;

  @override
  bool get isAuthenticated =>
      _account.value != null && _accessToken.value != null;
  @override
  Rxn<Account> get account => _account;

  @override
  RxnString get accessToken => _accessToken;

  @override
  RxBool get isLoading => _isLoading;

  @override
  void onInit() {
    super.onInit();
    _authService.userStream.listen((User? user) {
      if (user == null) {
        _account.value = null;
        _accessToken.value = null;
      } else {
        _account.value = AccountModel(
          name: user.displayName ?? user.email ?? 'Unknown',
          email: user.email ?? '',
        );
      }
    });
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    _isLoading.value = true;
    try {
      final result = await _authService.signInEmailAndPassword(
        email: email,
        password: password,
      );
      _account.value = result;
      _accessToken.value = result.accessToken;
      Get.toNamed('/');
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        _formatError(e),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.2),
        colorText: Get.theme.colorScheme.error,
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    _isLoading.value = true;
    try {
      final result = await _authService.signInWithGoogle();
      _account.value = result;
      _accessToken.value = result.accessToken;
      Get.toNamed('/');
    } catch (e) {
      Get.snackbar(
        'Google Sign-In Failed',
        _formatError(e),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.2),
        colorText: Get.theme.colorScheme.error,
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Extracts a meaningful error message from an exception.
  String _formatError(Object error) {
    if (error is FirebaseAuthException) {
      return error.message ?? 'An unknown Firebase error occurred';
    }
    return error.toString();
  }

  @override
  Future<void> signUpWithEmail(String email, String password) async {
    _isLoading.value = true;
    try {
      final result = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      _account.value = result;
      _accessToken.value = result.accessToken;
      Get.toNamed('/'); // Or route to a welcome/setup page if needed
    } catch (e) {
      Get.snackbar(
        'Sign Up Failed',
        _formatError(e),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.2),
        colorText: Get.theme.colorScheme.error,
        duration: const Duration(seconds: 3),
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
