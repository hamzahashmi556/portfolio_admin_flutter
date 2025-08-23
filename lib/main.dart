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
        title: 'Portfolio Admin',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
        ),
        home: Scaffold(
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
        ),
        // routes: {
        //   '/': (context) => const HomeScreen(),
        //   // '/editBasicInfo': (context) => const EditInfoScreen(),
        //   // '/projects': (context) => const ProjectListScreen(),
        // },
        // home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
