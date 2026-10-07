import 'package:employee_directory/core/network/api_exception.dart';
import 'package:employee_directory/repositories/auth_repository.dart';
import 'package:flutter/foundation.dart';


class PasswordResetProvider extends ChangeNotifier {
  final AuthRepository _repo;

  PasswordResetProvider(this._repo);

  String _email = '';
  bool _otpVerified = false;
  bool _isLoading = false;
  String? _errorMessage;

  String get email => _email;
  bool get otpVerified => _otpVerified;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Call when the flow begins, so old state never leaks into a new attempt.
  void start() {
    _email = '';
    _otpVerified = false;
    _isLoading = false;
    _errorMessage = null;
  }

  Future<bool> sendOtp(String email) async {
    final ok = await _run(() => _repo.sendOtp(email.trim()));
    if (ok) {
      _email = email.trim();
      _otpVerified = false;
    }
    return ok;
  }

  Future<bool> resendOtp() => _run(() => _repo.sendOtp(_email));

  Future<bool> verifyOtp(String otp) async {
    final ok = await _run(() => _repo.verifyOtp(_email, otp.trim()));
    if (ok) _otpVerified = true;
    return ok;
  }

  Future<bool> resetPassword(String newPassword) async {
    if (!_otpVerified) {
      _errorMessage = 'Please verify your OTP first.';
      notifyListeners();
      return false;
    }
    final ok = await _run(() => _repo.resetPassword(_email, newPassword));
    if (ok) start(); // flow finished: clear everything
    return ok;
  }

  /// Shared loading / error handling for all three calls.
  Future<bool> _run(Future<void> Function() action) async {
    if (_isLoading) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await action();
      _isLoading = false;
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }
}