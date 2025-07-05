import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/basic_info/views/edit_info_screen.dart';
import 'package:portfolio_admin/firebase_options.dart';
import 'package:portfolio_admin/home.dart';
import 'package:portfolio_admin/features/basic_info/views/basic_info_screen.dart';

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
    return MaterialApp(
      title: 'Portfolio Admin',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      routes: {
        '/': (context) => const HomeScreen(),
        '/editBasicInfo': (context) => const EditInfoScreen(),
      },
      // home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
