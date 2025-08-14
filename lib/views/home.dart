import 'package:flutter/material.dart';
import 'package:portfolio_admin/provider/info_provider.dart';
import 'package:portfolio_admin/views/project_list_screen.dart';
import 'package:portfolio_admin/widgets/cards/bio_card.dart';
import 'package:portfolio_admin/widgets/cards/experience_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InfoProvider>(context, listen: true);
    // final info = provider.info;
    // final expreinceList = provider.experiences;
    // final projects = provider.projects;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Portfolio Admin Panel"),
        actions: [
          IconButton(
            onPressed: provider.loadData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.loadData,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  BioCard(),
                  const Divider(),
                  ExperienceCard(),
                  ProjectListScreen(),
                  // ProjectCard(),
                  // buildProjectList(projects),
                ],
              ),
            ),
    );
  }
}
