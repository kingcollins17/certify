// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Authentication examples in Dart (Flutter-compatible)

void main() {
  // Replace this with your Flutter app setup and Firebase initialization.
}

/// Example: Listen to auth state changes.
/// Useful to track if a user is signed in or signed out.
void listenToAuthChanges() {
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      print('User is signed in: ${user.uid}');
    } else {
      print('User is signed out.');
    }
  });
}

/// Example: Get the current user using sign-in credentials.
Future<void> signInAndGetUser(AuthCredential credential) async {
  final userCredential = await FirebaseAuth.instance.signInWithCredential(
    credential,
  );
  final user = userCredential.user;
  print('Signed in user ID: ${user?.uid}');
}

/// Example: Get the current user if already signed in.
void getCurrentUser() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    print('Current user ID: ${user.uid}');
  } else {
    print('No user is currently signed in.');
  }
}

/// Example: Access provider-specific info like display name, email, etc.
void getProviderData(User user) {
  for (final providerProfile in user.providerData) {
    final provider = providerProfile.providerId;
    final uid = providerProfile.uid;
    final name = providerProfile.displayName;
    final email = providerProfile.email;
    final photo = providerProfile.photoURL;

    print('Provider: $provider, UID: $uid');
    print('Name: $name, Email: $email, Photo URL: $photo');
  }
}

/// Example: Update display name and profile picture.
Future<void> updateProfile(User? user) async {
  await user?.updateDisplayName("Jane Q. User");
  await user?.updatePhotoURL("https://example.com/jane-q-user/profile.jpg");
  print('Profile updated!');
}

/// Example: Update the user's email address.
/// Note: User must have recently signed in.
Future<void> updateEmail(User? user) async {
  await user?.updateEmail("janeq@example.com");
  print('Email updated!');
}

/// Example: Send a verification email to the user.
Future<void> sendEmailVerification(User? user) async {
  await FirebaseAuth.instance.setLanguageCode("fr"); // Optional: Set language
  await user?.sendEmailVerification();
  print('Verification email sent!');
}

/// Example: Update the user's password.
/// Note: User must have recently signed in.
Future<void> updatePassword(User? user, String newPassword) async {
  await user?.updatePassword(newPassword);
  print('Password updated!');
}

/// Example: Send a password reset email.
Future<void> sendPasswordResetEmail(String email) async {
  await FirebaseAuth.instance.setLanguageCode("fr"); // Optional: Set language
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  print('Password reset email sent!');
}

/// Example: Delete a user account.
/// Note: User must have recently signed in.
Future<void> deleteUser(User? user) async {
  await user?.delete();
  print('User account deleted.');
}

/// Example: Re-authenticate a user with credentials before sensitive ops.
Future<void> reAuthenticate(User? user, AuthCredential credential) async {
  await user?.reauthenticateWithCredential(credential);
  print('User re-authenticated.');
}

/// Example: Firebase CLI command for importing users from file.
/// This is just for reference, not to be run in Dart.
/// Command:
/// firebase auth:import users.json --hash-algo=scrypt --rounds=8 --mem-cost=14
