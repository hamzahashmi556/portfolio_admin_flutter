import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;
  final FirebaseAuth _auth;

  Stream<User?> authState() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  /// Web-friendly Google sign-in
  Future<UserCredential> signInWithGoogle() async {
    final googleProvider = GoogleAuthProvider();
    if (kIsWeb) {
      return _auth.signInWithPopup(googleProvider);
    } else {
      // For mobile you’d use google_sign_in; not needed for web admin right now.
      throw UnimplementedError(
        'Use web signInWithPopup or implement mobile flow.',
      );
    }
  }

  Future<void> signOut() => _auth.signOut();
}
