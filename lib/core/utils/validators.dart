class Validators {
  Validators._();

  static String? required(String? value, [String field = 'This field']) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? mobile(String? value) {
  if (value == null || value.trim().isEmpty) return 'Mobile number is required';
  final digits = value.replaceAll(RegExp(r'[\s\-+]'), '');
  if (!RegExp(r'^\d{10,13}$').hasMatch(digits)) {
    return 'Enter a valid mobile number';
  }
  return null;
}
}