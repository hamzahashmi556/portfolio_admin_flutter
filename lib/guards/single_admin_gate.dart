import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/admin_config.dart';
import '../views/login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.child});
  final Widget child;

  bool _isAllowed(User? u) {
    if (u == null) return false;
    final emailOk =
        (u.email ?? '').toLowerCase() == AdminConfig.allowedEmail.toLowerCase();
    final uidOk =
        AdminConfig.allowedUid.isNotEmpty && u.uid == AdminConfig.allowedUid;
    // allow if either matches (you can change to uid-only if you prefer)
    return emailOk || uidOk;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snap.data;
        if (!_isAllowed(user)) {
          // If signed in but not allowed, tell them and sign out.
          if (user != null) {
            return _NotAuthorized(userEmail: user.email ?? user.uid);
          }
          // Not signed in → show login
          return LoginScreen(
            presetEmail: AdminConfig.allowedEmail, // autofill for you
            showGoogle: false, // single admin → you likely don't need Google
          );
        }
        return child;
      },
    );
  }
}

class _NotAuthorized extends StatelessWidget {
  const _NotAuthorized({required this.userEmail});
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 48),
            const SizedBox(height: 12),
            Text('Not authorized: $userEmail'),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
