import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_admin/firebase_options.dart';
import 'package:portfolio_admin/provider/info_provider.dart';
import 'package:portfolio_admin/services/auth/auth_gate.dart';
import 'package:portfolio_admin/views/home.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Put this after WidgetsFlutterBinding.ensureInitialized();
  FlutterError.demangleStackTrace = (StackTrace stack) {
    // Try to demangle web stack traces so types/lines are meaningful
    if (stack is StackTrace) return stack;
    try {
      final stackString = stack.toString();
      // In debug this is enough; in release you'll still want to run debug once.
      return StackTrace.fromString(stackString);
    } catch (_) {
      return stack;
    }
  };

  // 🔴 Make runtime errors visible on web (rather than a blank page)
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // Also log to console
    // ignore: avoid_print
    print('FlutterError: ${details.exception}');
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    // ignore: avoid_print
    print('Uncaught zone error: $error');
    // Return true to mark as handled
    return true;
  };

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const PortfolioAdmin());
}

class PortfolioAdmin extends StatelessWidget {
  const PortfolioAdmin({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => InfoProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Portfolio Admin',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
        ),
        // ✅ Use builder ONLY to customize the error widget
        builder: (context, child) {
          ErrorWidget.builder = (FlutterErrorDetails details) {
            return Scaffold(
              appBar: AppBar(title: const Text('Portfolio Admin (Error)')),
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SelectableText(
                        '⚠️ Widget error:\n\n${details.exceptionAsString()}',
                      ),
                    ),
                  ),
                ),
              ),
            );
          };
          // IMPORTANT: return the provided child here (don’t replace the app)
          return child!;
        },
        // ✅ Set a real home for the app
        home: const _RootShell(),

        // home:
        // routes: {
        //   '/': (context) => const HomeScreen(),
        //   // '/editBasicInfo': (context) => const EditInfoScreen(),
        //   // '/projects': (context) => const ProjectListScreen(),
        // },
        // home: HomeScreen(),
      ),
    );
  }
}

class _RootShell extends StatelessWidget {
  const _RootShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio Admin'),
        actions: [
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snap) {
              final u = snap.data;
              if (u == null) return const SizedBox.shrink();
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      u.email ?? u.uid,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  IconButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    icon: const Icon(Icons.logout),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: const AuthGate(child: HomeScreen()),
    );
  }
}
