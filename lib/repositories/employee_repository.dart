import 'package:dio/dio.dart';
import 'package:employee_directory/core/constants/api_constants.dart';
import '../core/network/api_exception.dart';
import '../core/utils/json_utils.dart';
import '../models/employee.dart';

class EmployeePage {
  final List<Employee> employees;
  final int page;
  final int totalPages;
  final int total;

  const EmployeePage({
    required this.employees,
    required this.page,
    required this.totalPages,
    required this.total,
  });
}

class EmployeeRepository {
  final Dio _dio;

  EmployeeRepository(this._dio);

  Future<EmployeePage> getEmployees({
    String? search,
    int? departmentId,
    int page = 1,
  }) async {
    try {
      final res = await _dio.get(
        ApiConstants.employeeList,
        queryParameters: {
          'page': page,
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
          'department_id': ?departmentId,
        },
      );

      final body = res.data;
      if (body is! Map || body['data'] is! List) {
        throw const ApiException('Could not load employees.');
      }

      final employees = (body['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(Employee.fromJson)
          .toList();

      return EmployeePage(
        employees: employees,
        page: parseInt(body['page']) ?? page,
        totalPages: parseInt(body['totalPages']) ?? 1,
        total: parseInt(body['total']) ?? employees.length,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}