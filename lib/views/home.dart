import 'package:flutter/material.dart';
import 'package:portfolio_admin/provider/info_provider.dart';
import 'package:portfolio_admin/features/project/widgets/project_list_screen.dart';
import 'package:portfolio_admin/features/basic_info/widgets/bio_card.dart';
import 'package:portfolio_admin/features/experience/widgets/experience_card.dart';
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
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return RefreshIndicator(
        onRefresh: provider.loadData,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            Expanded(child: BioCard()),
            const Divider(),
            Expanded(child: ExperienceCard()),
            const Divider(),
            Expanded(child: ProjectListScreen()),
            // ProjectCard(),
            // buildProjectList(projects),
          ],
        ),
      );
    }
  }
}
