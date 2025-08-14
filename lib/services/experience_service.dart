import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_admin/model/expreince.dart';

class ExperienceService {
  static ExperienceService instance = ExperienceService._privateConstructor();

  ExperienceService._privateConstructor();

  final _dbRef = FirebaseFirestore.instance.collection('experience');

  Future<List<Experience>> getAll() async {
    try {
      final snapshot = await _dbRef.get();
      final docs = snapshot.docs;
      final list = docs.map((doc) {
        return Experience.fromMap(doc.data(), doc.id);
      }).toList();
      return list;
    } catch (e) {
      log('error getting experience $e');
      rethrow;
    }
  }

  Future<void> add(Experience experience) async {
    try {
      await _dbRef.add(experience.toMap());
    } catch (e) {
      log('error adding experience $e');
      rethrow;
    }
  }

  Future<void> edit(Experience experience) async {
    if (experience.docId == null) {
      return;
    }
    try {
      await _dbRef.doc(experience.docId).set(experience.toMap());
    } catch (e) {
      log('error adding experience $e');
      rethrow;
    }
  }

  Future<void> delete(Experience experience) async {
    if (experience.docId == null) {
      return;
    }
    try {
      await _dbRef.doc(experience.docId).delete();
    } catch (e) {
      log('error adding experience $e');
      rethrow;
    }
  }
}
