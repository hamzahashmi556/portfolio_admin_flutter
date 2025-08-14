import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:portfolio_admin/model/expreince.dart';
import 'package:portfolio_admin/model/project.dart';
import 'package:portfolio_admin/services/bio_service.dart';
import 'package:portfolio_admin/services/experience_service.dart';
import 'package:portfolio_admin/services/project_service.dart';
import '../model/basic_info.dart';

class InfoProvider with ChangeNotifier {
  BasicInfo? _info;
  List<Experience> _experiences = [];
  List<Project> _projects = [];

  BasicInfo? get info => _info;
  List<Project> get projects => _projects;
  List<Experience> get experiences => _experiences;

  bool isLoading = true;
  String bioError = '';
  String experienceError = '';
  String projectsError = '';

  InfoProvider() {
    loadData();
  }

  Future<void> loadData() async {
    try {
      _info = await BioService.instance.getBasicInfo();
    } catch (e) {
      bioError = "Bio Error ${e.toString()}";
    }
    try {
      _projects = await ProjectService.instance.getAll();
    } catch (e) {
      projectsError = "Bio Error ${e.toString()}";
    }
    try {
      _experiences = await ExperienceService.instance.getAll();
    } catch (e) {
      experienceError = "Bio Error ${e.toString()}";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> setBio(BasicInfo newInfo) async {
    try {
      await BioService.instance.setBasicInfo(newInfo);
      _info = newInfo;
    } catch (e) {
      log('error updating info $e');
    }
    notifyListeners();
  }

  // void updateExperienceList(List<Experience> updatedList) {
  //   if (_info != null) {
  //     _info = _info!.copyWith(experienceList: updatedList);
  //     notifyListeners();
  //   }
  // }

  // void updateSkills(List<String> updatedSkills) {
  //   if (_info != null) {
  //     _info = _info!.copyWith(skills: updatedSkills);
  //     notifyListeners();
  //   }
  // }
}
