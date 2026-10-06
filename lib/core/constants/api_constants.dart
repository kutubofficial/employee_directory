class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://ed.alobhadev.com/api';

  static const String imageBaseUrl = 'https://ed.alobhadev.com/';

  static const String departments = '/master';
  static const String register = '/user/registration';
  static const String login = '/user/login';
  static const String sendOtp = '/user/send-otp';
  static const String verifyOtp = '/user/verify-otp';
  static const String resetPassword = '/user/reset-password';
  static const String employeeList = '/user/employee-list';
  static const String profile = '/user/profile';
  static const String viewEmployee = '/user/view-employee';

  static String? imageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    final clean = path.startsWith('/') ? path.substring(1) : path;
    return '$imageBaseUrl$clean';
  }
}