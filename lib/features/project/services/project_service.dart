import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_admin/features/project/model/project.dart';

class ProjectService {
  ProjectService._();
  static final ProjectService instance = ProjectService._();

  CollectionReference<Map<String, dynamic>> get _col => FirebaseFirestore
      .instance
      .collection('portfolioData')
      .doc('info')
      .collection('projects');

  Stream<List<Project>> stream() {
    return _col
        .orderBy('featured', descending: true)
        .orderBy('sortOrder')
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Project.fromDoc(d)).toList());
  }

  Future<void> add(Project p) async => _col.add(p.toMap());
  Future<void> update(Project p) async => _col.doc(p.id).update(p.toMap());
  Future<void> delete(String id) async => _col.doc(id).delete();
}
