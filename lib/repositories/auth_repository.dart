import 'package:dio/dio.dart';
import 'package:employee_directory/core/constants/api_constants.dart';
import 'package:employee_directory/core/network/api_exception.dart';
import 'package:employee_directory/models/employee.dart';


class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  /// Returns the JWT token. The API sends no user object on login.
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      final token = res.data['token'];
      if (token is! String || token.isEmpty) {
        throw const ApiException('Login failed. Please try again.');
      }
      return token;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Needs the Bearer token (AuthInterceptor adds it automatically).
  Future<Employee> getProfile() async {
    try {
      final res = await _dio.get(ApiConstants.profile);
      final data = res.data['data'];
      if (data is! Map<String, dynamic>) {
        throw const ApiException('Could not load your profile.');
      }
      return Employee.fromJson(data);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Multipart request. Registration returns no token, so the user logs in afterwards.
  Future<void> register({
    required String fullName,
    required String employeeId,
    required String email,
    required String mobileNumber,
    required String password,
    required String dateOfJoining, // "yyyy-MM-dd"
    required int departmentId,
    required String designation,
    required String imagePath,
  }) async {
    try {
      final form = FormData.fromMap({
        'full_name': fullName,
        'unique_employee_id': employeeId,
        'email': email,
        'mobile_number': mobileNumber,
        'password': password,
        'date_of_joining': dateOfJoining,
        'department_id': departmentId.toString(),
        'designation': designation,
        'user_img': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split(RegExp(r'[\\/]')).last,
        ),
      });
      await _dio.post(ApiConstants.register, data: form);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  Future<void> sendOtp(String email) =>
    _post(ApiConstants.sendOtp, {'email': email});

Future<void> verifyOtp(String email, String otp) =>
    _post(ApiConstants.verifyOtp, {'email': email, 'otp': otp});

Future<void> resetPassword(String email, String newPassword) => _post(
      ApiConstants.resetPassword,
      {'email': email, 'new_password': newPassword},
    );

Future<void> _post(String path, Map<String, dynamic> body) async {
  try {
    await _dio.post(path, data: body);
  } on DioException catch (e) {
    throw ApiException.fromDio(e);
  }
}
}