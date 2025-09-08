import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portfolio_admin/features/project/model/project.dart';

class ProjectService {
  ProjectService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection('users').doc(uid).collection('projects');

  Stream<List<Project>> streamProjects() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    Query<Map<String, dynamic>> q = _col(uid).orderBy('startDate');
    return q.snapshots().map((snap) => snap.docs.map(Project.fromDoc).toList());
  }

  Future<String> create(Project project) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Future.error('unable to get user');
    final ref = _col(uid).doc(); // generate id server-side
    await ref.set(project.copyWith(id: ref.id).toMapForWrite(isCreate: true));
    return ref.id;
  }

  Future<void> update(Project project) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Future.error('unable to get user');
    final id = project.id;
    if (id == null || id.isEmpty) {
      throw StateError('Project id is required for update');
    }
    await _col(uid).doc(id).update(project.toMapForWrite(isCreate: false));
  }

  Future<void> delete(String id) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Future.error('unable to get user');
    await _col(uid).doc(id).delete();
  }
}
