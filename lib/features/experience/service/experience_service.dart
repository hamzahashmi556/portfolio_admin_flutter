import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfolio_admin/features/experience/model/experience.dart';

class ExperienceService {
  ExperienceService._();

  static final ExperienceService instance = ExperienceService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('experience');

  Stream<List<Experience>> stream() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return _col(uid)
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Experience.fromDoc(d)).toList());
  }

  Future<List<Experience>> fetch() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    final qs = await _col(uid).orderBy('startDate', descending: true).get();
    return qs.docs.map((d) => Experience.fromDoc(d)).toList();
  }

  Future<void> add(Experience e) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _col(uid).add(e.toMap());
  }

  Future<void> update(Experience e) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _col(uid).doc(e.id).update(e.toMap());
  }

  Future<void> delete(String id) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _col(uid).doc(id).delete();
  }
}
