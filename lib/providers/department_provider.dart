import 'package:flutter/foundation.dart';
import '../core/network/api_exception.dart';
import '../core/utils/view_status.dart';
import '../models/department.dart';
import '../repositories/department_repository.dart';

class DepartmentProvider extends ChangeNotifier {
  final DepartmentRepository _repo;

  DepartmentProvider(this._repo);

  ViewStatus _status = ViewStatus.initial;
  List<Department> _departments = [];
  String? _errorMessage;

  ViewStatus get status => _status;
  List<Department> get departments => _departments;
  String? get errorMessage => _errorMessage;

  /// Safe to call from several screens: it won't refetch once loaded.
  Future<void> load({bool force = false}) async {
    if (_status == ViewStatus.loading) return;
    if (_status == ViewStatus.success && !force) return;

    _status = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _departments = await _repo.getDepartments();
      _status = _departments.isEmpty ? ViewStatus.empty : ViewStatus.success;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = ViewStatus.error;
    }
    notifyListeners();
  }
}