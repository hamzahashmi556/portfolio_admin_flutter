import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/experience/model/experience.dart';
import 'package:portfolio_admin/features/basic_info/service/bio_service.dart';
import 'package:portfolio_admin/features/experience/service/experience_service.dart';
import '../features/basic_info/model/basic_info.dart';

class InfoProvider with ChangeNotifier {
  BasicInfo? _info;
  BasicInfo? get info => _info;
  String bioError = '';

  List<Experience> _experiences = [];
  List<Experience> get experiences => _experiences;
  String experienceError = '';

  // List<Project> _projects = [];
  // List<Project> get projects => _projects;
  // String projectsError = '';

  bool isLoading = true;

  InfoProvider() {
    loadData();
  }

  Future<void> loadData() async {
    try {
      _info = await BioService.instance.getBasicInfo();
    } catch (e) {
      bioError = "Bio Error ${e.toString()}";
    }
    // try {
    //   _projects = await ProjectService.instance.fetch();
    // } catch (e) {
    //   projectsError = "Bio Error ${e.toString()}";
    // }
    try {
      _experiences = await ExperienceService.instance.fetch();
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

  void addExperience(Experience exp) async {
    try {
      ExperienceService.instance.add(exp);
      _experiences.add(exp);
    } catch (e) {
      log('error adding experience $e');
    }
    notifyListeners();
  }

  void updateExperience(Experience exp) async {
    var index = experiences.indexWhere((current) {
      return current.title == exp.title;
    });
    if (index > experiences.length - 1) {
      return;
    }
    try {
      await ExperienceService.instance.update(exp);
      _experiences[index] = exp;
    } catch (e) {
      log('error updating experience $e');
    }
    notifyListeners();
  }
}
