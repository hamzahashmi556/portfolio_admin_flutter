import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_admin/services/auth/auth_service.dart';
import 'package:portfolio_admin/views/login_screen.dart';

/// Wrap your Home with this gate:
/// AuthGate(
///   child: AdminGuard(child: HomeScreen()),
/// )
class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return StreamBuilder<User?>(
      stream: auth.authState(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snap.data;
        if (user == null) return const LoginScreen();
        return child;
      },
    );
  }
}

/// Ensures the signed-in user is an admin.
/// Firestore rule: collection `admins/{uid}` with a document existing for admins.
class AdminGuard extends StatelessWidget {
  const AdminGuard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = FirebaseFirestore.instance.collection('admins').doc(uid);

    return FutureBuilder(
      future: doc.get(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final exists = (snap.data?.exists ?? false);
        if (!exists) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline, size: 42),
                  const SizedBox(height: 12),
                  const Text('Access restricted to admins'),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => AuthService().signOut(),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          );
        }
        return child;
      },
    );
  }
}
