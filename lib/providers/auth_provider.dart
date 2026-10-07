import 'package:employee_directory/core/network/api_exception.dart';
import 'package:employee_directory/core/storage/token_storage.dart';
import 'package:employee_directory/core/utils/view_status.dart';
import 'package:employee_directory/models/employee.dart';
import 'package:employee_directory/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';


class AuthProvider extends ChangeNotifier {
  final AuthRepository _repo;
  final TokenStorage _tokenStorage;

  AuthProvider(this._repo, this._tokenStorage);

  ViewStatus _status = ViewStatus.initial;
  String? _errorMessage;
  Employee? _user;
  bool _initialized = false; // true once the startup session check is done

  ViewStatus get status => _status;
  String? get errorMessage => _errorMessage;
  Employee? get user => _user;
  bool get initialized => _initialized;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _status == ViewStatus.loading;

  Future<bool> login(String email, String password) async {
    if (isLoading) return false; // ignore double taps
    _setLoading();
    try {
      final token = await _repo.login(email: email.trim(), password: password);
      await _tokenStorage.saveToken(token); // must come before getProfile
      _user = await _repo.getProfile();
      _status = ViewStatus.success;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      await _tokenStorage.clearToken(); // no half-finished session
      _user = null;
      _setError(e.message);
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String employeeId,
    required String email,
    required String mobileNumber,
    required String password,
    required String dateOfJoining,
    required int departmentId,
    required String designation,
    required String imagePath,
  }) async {
    if (isLoading) return false;
    _setLoading();
    try {
      await _repo.register(
        fullName: fullName.trim(),
        employeeId: employeeId.trim(),
        email: email.trim(),
        mobileNumber: mobileNumber.trim(),
        password: password,
        dateOfJoining: dateOfJoining,
        departmentId: departmentId,
        designation: designation.trim(),
        imagePath: imagePath,
      );
      _status = ViewStatus.success;
      notifyListeners();
      return true; // no token from the API, so the user logs in next
    } on ApiException catch (e) {
      _setError(e.message);
      return false;
    }
  }

  /// Called once by the splash screen.
  Future<void> tryAutoLogin() async {
    try {
      final token = await _tokenStorage.getToken();
      if (token == null || token.isEmpty) return;
      _user = await _repo.getProfile();
    } on ApiException catch (e) {
      // Expired token: clear it. Other errors (e.g. offline): keep the token
      // so the next launch retries, and the user lands on the login screen.
      if (e.isUnauthorized) await _tokenStorage.clearToken();
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clearToken();
    _user = null;
    _status = ViewStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
    _status = ViewStatus.initial;
    notifyListeners();
  }

  void _setLoading() {
    _status = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = ViewStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}