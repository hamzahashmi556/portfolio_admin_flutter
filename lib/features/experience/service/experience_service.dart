import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_admin/features/experience/model/experience.dart';

class ExperienceService {
  ExperienceService._();
  static final ExperienceService instance = ExperienceService._();

  CollectionReference<Map<String, dynamic>> get _col => FirebaseFirestore
      .instance
      .collection('portfolioData')
      .doc('info')
      .collection('experience');

  Stream<List<Experience>> stream() {
    return _col
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Experience.fromDoc(d)).toList());
  }

  Future<List<Experience>> fetch() async {
    final qs = await _col.orderBy('startDate', descending: true).get();
    return qs.docs.map((d) => Experience.fromDoc(d)).toList();
  }

  Future<void> add(Experience e) async {
    await _col.add(e.toMap());
  }

  Future<void> update(Experience e) async {
    await _col.doc(e.id).update(e.toMap());
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
