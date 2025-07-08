import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// This function handles the entire Google Sign-In flow in a Flutter app.
///
/// It uses the `google_sign_in` plugin to:
/// - Trigger the Google authentication UI.
/// - Obtain the user's access and ID tokens.
/// - Create a Firebase credential from those tokens.
/// - Authenticate the user with Firebase using that credential.
///
/// Returns a [UserCredential] object representing the signed-in user.
Future<UserCredential> signInWithGoogle() async {
  // Step 1: Start the Google Sign-In flow.
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // If the user cancels the sign-in flow, return early.
  if (googleUser == null) {
    throw FirebaseAuthException(
      code: 'ERROR_ABORTED_BY_USER',
      message: 'Sign in aborted by user',
    );
  }

  // Step 2: Retrieve the authentication tokens from Google.
  final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

  // Step 3: Create a Firebase credential using the tokens from Google.
  final OAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Step 4: Sign in to Firebase with the Google credential.
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
