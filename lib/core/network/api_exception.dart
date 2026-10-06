import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  bool get isUnauthorized => statusCode == 401;

  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const ApiException('No internet connection.');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        return ApiException(_serverMessage(e.response) ?? _byStatus(code),
            statusCode: code);
      default:
        return const ApiException('Something went wrong. Please try again.');
    }
  }

  /// The backend sends errors as JSON like {"success": false, "message": "..."}
  static String? _serverMessage(Response? response) {
    final data = response?.data;
    if (data is Map && data['message'] is String) {
      final msg = (data['message'] as String).trim();
      if (msg.isNotEmpty) return msg;
    }
    return null;
  }

  static String _byStatus(int? code) {
    if (code == 401) return 'Session expired. Please log in again.';
    if (code != null && code >= 500) {
      return 'Server error. Please try again later.';
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  String toString() => message;
}