import 'dart:async';
import 'package:flutter/foundation.dart';
import '../core/network/api_exception.dart';
import '../core/utils/view_status.dart';
import '../models/employee.dart';
import '../repositories/employee_repository.dart';

class EmployeeListProvider extends ChangeNotifier {
  final EmployeeRepository _repo;

  EmployeeListProvider(this._repo);

  ViewStatus _status = ViewStatus.initial;
  List<Employee> _employees = [];
  String? _errorMessage;
  String _search = '';
  int? _departmentId;
  int _page = 1;
  int _totalPages = 1;
  bool _loadingMore = false;
  int _requestId = 0; // lets us ignore responses from outdated requests
  Timer? _debounce;

  ViewStatus get status => _status;
  List<Employee> get employees => _employees;
  String? get errorMessage => _errorMessage;
  int? get departmentId => _departmentId;
  String get search => _search;
  bool get loadingMore => _loadingMore;
  bool get hasMore => _page < _totalPages;

  /// Loads page 1 with the current search and department filter.
  Future<void> load() async {
    final id = ++_requestId;
    _loadingMore = false;
    _page = 1;
    _status = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repo.getEmployees(
        search: _search,
        departmentId: _departmentId,
        page: 1,
      );
      if (id != _requestId) return; // a newer request replaced this one
      _employees = result.employees;
      _totalPages = result.totalPages;
      _status = _employees.isEmpty ? ViewStatus.empty : ViewStatus.success;
    } on ApiException catch (e) {
      if (id != _requestId) return;
      _errorMessage = e.message;
      _status = ViewStatus.error;
    }
    notifyListeners();
  }

  /// Called when the list is scrolled near the bottom.
  Future<void> loadMore() async {
    if (_loadingMore || !hasMore || _status != ViewStatus.success) return;
    final id = _requestId;
    _loadingMore = true;
    notifyListeners();

    try {
      final result = await _repo.getEmployees(
        search: _search,
        departmentId: _departmentId,
        page: _page + 1,
      );
      if (id != _requestId) return;
      _page += 1;
      _totalPages = result.totalPages;
      _employees = [..._employees, ...result.employees];
    } on ApiException {
      // Keep what we have; the next scroll to the bottom tries again.
    } finally {
      if (id == _requestId) {
        _loadingMore = false;
        notifyListeners();
      }
    }
  }

  /// Waits 400 ms after the last keystroke before calling the API.
  void setSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final trimmed = query.trim();
      if (trimmed == _search) return;
      _search = trimmed;
      load();
    });
  }

  void setDepartment(int? departmentId) {
    if (departmentId == _departmentId) return;
    _departmentId = departmentId;
    load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}