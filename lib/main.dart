import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_admin/firebase_options.dart';
import 'package:portfolio_admin/provider/info_provider.dart';
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
        routes: {
          '/': (context) => const HomeScreen(),
          // '/editBasicInfo': (context) => const EditInfoScreen(),
          // '/projects': (context) => const ProjectListScreen(),
        },
        // home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
