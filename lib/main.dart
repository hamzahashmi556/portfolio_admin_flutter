import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/project_info/views/project_list_screen.dart';
import 'package:portfolio_admin/firebase_options.dart';
import 'package:portfolio_admin/home.dart';
import 'package:portfolio_admin/features/basic_info/views/basic_info_screen.dart';
import 'package:portfolio_admin/features/project_info/views/project_form.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: const AdminHome(),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
