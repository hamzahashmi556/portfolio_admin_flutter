// lib/features/project/projects_provider.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:portfolio_admin/features/project/model/project.dart';
import 'package:portfolio_admin/features/project/services/project_service.dart';
import 'package:portfolio_admin/features/project/widgets/project_editor.dart';

/// Streams ALL projects from Firestore (no where/orderBy),
/// then filters/sorts on the client.
class ProjectsProvider with ChangeNotifier {
  ProjectsProvider({required this.service});

  final ProjectService service;

  // Internal state
  StreamSubscription<List<Project>>? _sub;
  final List<Project> _all = [];
  String _query = '';
  bool _onlyFeatured = false;
  String? _lastError;

  // ---------------------------
  // Public getters
  // ---------------------------

  /// Filtered + sorted list (client-side only)
  List<Project> get projects {
    // 1) clone
    var list = List<Project>.from(_all);

    // 2) client-side search
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((p) {
        if (p.title.toLowerCase().contains(q)) return true;
        if ((p.subtitle ?? '').toLowerCase().contains(q)) return true;
        if (p.description.toLowerCase().contains(q)) return true;
        if (p.tech.any((t) => t.toLowerCase().contains(q))) return true;
        if (p.tags.any((t) => t.toLowerCase().contains(q))) return true;
        return false;
      }).toList();
    }

    // 3) client-side featured filter
    if (_onlyFeatured) {
      list = list.where((p) => p.featured).toList();
    }

    // 4) client-side sort
    // Primary: order (asc)
    // Secondary (stable): title (asc) to keep a deterministic layout
    list.sort((a, b) {
      final byOrder = a.order.compareTo(b.order);
      if (byOrder != 0) return byOrder;
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });

    return list;
  }

  String get query => _query;
  bool get onlyFeatured => _onlyFeatured;
  String? get error => _lastError;

  // ---------------------------
  // Lifecycle
  // ---------------------------

  /// Call once (e.g., in initState of your screen).
  /// IMPORTANT: your ProjectService.streamProjects() should return ALL docs
  /// without any where/orderBy to avoid composite indexes.
  void bind() {
    _sub?.cancel();
    _lastError = null;

    _sub = service.streamProjects().listen(
      (list) {
        // Replace in-place to keep reference stable if needed
        _all
          ..clear()
          ..addAll(list);
        notifyListeners();
      },
      onError: (e, st) {
        _lastError = e.toString();
        debugPrint('🔥 Projects stream error: $e');
        debugPrintStack(stackTrace: st);
        notifyListeners();
      },
      cancelOnError: false,
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  // ---------------------------
  // Mutations / filters (client-side)
  // ---------------------------

  set query(String v) {
    if (_query == v) return;
    _query = v;
    notifyListeners();
  }

  set onlyFeatured(bool v) {
    if (_onlyFeatured == v) return;
    _onlyFeatured = v;
    // No re-subscribe; we keep one stream of ALL projects.
    notifyListeners();
  }

  // ---------------------------
  // CRUD helpers (use your dialogs/widgets)
  // ---------------------------

  Future<void> addNew(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProjectEditorDialog(service: service),
    );
    // Stream updates automatically; nothing else to do.
    if (ok == true) {}
  }

  Future<void> edit(BuildContext context, Project p) async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProjectEditorDialog(service: service, initial: p),
    );
    if (ok == true) {}
  }

  Future<void> delete(Project p) async {
    final id = p.id;
    if (id == null || id.isEmpty) {
      debugPrint('⚠️ Cannot delete: project id is null/empty');
      return;
    }
    await service.delete(id);
  }

  Future<void> toggleFeatured(Project p) async {
    await service.update(p.copyWith(featured: !p.featured));
  }

  // ---------------------------
  // Export (for backups / seeding public site)
  // ---------------------------

  /// Export the CURRENT filtered list (client-side result) as JSON.
  String exportJson() {
    final data = projects.map((e) => e.toExportJson()).toList();
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// Export ALL raw docs (unfiltered) as JSON.
  String exportAllJson() {
    final data = _all.map((e) => e.toExportJson()).toList();
    return const JsonEncoder.withIndent('  ').convert(data);
  }
}
