// services/firestore_service.dart

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfolio_admin/features/basic_info/model/basic_info.dart';

class BioService {
  static BioService instance = BioService._privateConstructor();

  BioService._privateConstructor();

  final _auth = FirebaseAuth.instance;

  DocumentReference<Map<String, dynamic>> _bioRef(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid);

  // Upload or Update Basic Info
  Future<void> setBasicInfo(BasicInfo info) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    try {
      await _bioRef(uid).set(info.toMap());
      log("✅ Basic Info Saved");
    } catch (e) {
      log("❌ Error saving basic info: $e");
      rethrow;
    }
  }

  // Get Basic Info
  Future<BasicInfo?> getBasicInfo() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    try {
      final doc = await _bioRef(uid).get();

      if (doc.exists) {
        return BasicInfo.fromMap(doc.data()!);
      }
    } catch (e) {
      log("❌ Error fetching basic info: $e");
      rethrow;
    }
    return null;
  }
}
