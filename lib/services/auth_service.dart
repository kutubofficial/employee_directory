import 'package:dio/dio.dart';
import 'package:employee_directory/core/constants/api_constants.dart';
import 'package:employee_directory/core/network/api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await _apiClient.post(
      ApiConstants.login,
      data: {
        'email': email,
        'password': password,
      },
    );
  }
}