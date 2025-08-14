// services/firestore_service.dart

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_admin/model/basic_info.dart';

class BioService {
  static BioService instance = BioService._privateConstructor();

  BioService._privateConstructor();

  final _bioRef = FirebaseFirestore.instance
      .collection('portfolioData')
      .doc('info');

  // Upload or Update Basic Info
  Future<void> setBasicInfo(BasicInfo info) async {
    try {
      await _bioRef.set(info.toMap());
      log("✅ Basic Info Saved");
    } catch (e) {
      log("❌ Error saving basic info: $e");
      rethrow;
    }
  }

  // Get Basic Info
  Future<BasicInfo?> getBasicInfo() async {
    try {
      final doc = await _bioRef.get();

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
