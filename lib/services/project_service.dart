import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_admin/model/project.dart';

class ProjectService {
  static ProjectService instance = ProjectService._privateConstructor();

  ProjectService._privateConstructor();

  final _dbRef = FirebaseFirestore.instance.collection('projects');

  Future<List<Project>> getAll() async {
    try {
      final query = await _dbRef.get();
      final list = query.docs
          .map((doc) => Project.fromMap(doc.data(), doc.id))
          .toList();
      return list;
    } catch (e) {
      log("❌ Error getting projects: $e");
      rethrow;
    }
  }

  Future<void> add(Project project) async {
    try {
      await _dbRef.add(project.toMap());
    } catch (e) {
      log("❌ Error adding project: $e");
      rethrow;
    }
  }

  Future<void> edit(Project project) async {
    if (project.docId == null) {
      return;
    }
    try {
      await _dbRef.doc(project.docId).set(project.toMap());
    } catch (e) {
      log("❌ Error updating project: $e");
      rethrow;
    }
  }

  Future<void> delete(String projectId) async {
    try {
      await _dbRef.doc(projectId).delete();
    } catch (e) {
      log('error adding project $e');
      rethrow;
    }
  }
}
