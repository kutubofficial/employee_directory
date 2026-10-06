import 'package:dio/dio.dart';
import 'package:employee_directory/core/constants/api_constants.dart';
import '../core/network/api_exception.dart';
import '../models/department.dart';

class DepartmentRepository {
  final Dio _dio;

  DepartmentRepository(this._dio);

  Future<List<Department>> getDepartments() async {
    try {
      final res = await _dio.get(ApiConstants.departments);
      final list = res.data['data'];
      if (list is! List) {
        throw const ApiException('Could not load departments.');
      }
      return list
          .whereType<Map<String, dynamic>>()
          .map(Department.fromJson)
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}