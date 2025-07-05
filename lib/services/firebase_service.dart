// services/firestore_service.dart

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_admin/features/basic_info/model/basic_info.dart';
import 'package:portfolio_admin/features/project_info/model/project.dart';

class FirestoreService {
  static FirestoreService instance = FirestoreService._privateConstructor();

  FirestoreService._privateConstructor();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Upload or Update Basic Info
  Future<void> setBasicInfo(BasicInfo info) async {
    try {
      await _db.collection('portfolioData').doc('info').set(info.toMap());
      log("✅ Basic Info Saved");
    } catch (e) {
      log("❌ Error saving basic info: $e");
    }
  }

  // Get Basic Info
  Future<BasicInfo?> getBasicInfo() async {
    try {
      final doc = await _db.collection('portfolioData').doc('info').get();
      if (doc.exists) {
        return BasicInfo.fromMap(doc.data()!);
      }
    } catch (e) {
      log("❌ Error fetching basic info: $e");
    }
    return null;
  }

  // Add Project
  Future<void> addProject(Project project) async {
    try {
      await _db.collection('projects').add(project.toMap());
      log("✅ Project added");
    } catch (e) {
      log("❌ Error adding project: $e");
    }
  }

  Future<void> updateProject(String docId, Project project) async {
    try {
      await _db.collection('projects').doc(docId).set(project.toMap());
    } catch (e) {
      log("❌ Error updating project: $e");
    }
  }

  // Get All Projects
  Future<List<Project>> getAllProjects() async {
    try {
      final query = await _db.collection('projects').get();
      return query.docs
          .map((doc) => Project.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      log("❌ Error getting projects: $e");
      return [];
    }
  }

  // Delete Project (optional)
  Future<void> deleteProject(String docId) async {
    try {
      await _db.collection('projects').doc(docId).delete();
      log("🗑️ Project deleted");
    } catch (e) {
      log("❌ Error deleting project: $e");
    }
  }
}
