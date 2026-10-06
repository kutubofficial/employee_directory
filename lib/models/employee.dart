import 'package:employee_directory/core/constants/api_constants.dart';
import 'package:employee_directory/core/utils/json_utils.dart';
import 'package:intl/intl.dart';
import 'department.dart';

class Employee {
  final int id;
  final String fullName;
  final String uniqueEmployeeId;
  final String email;
  final String mobileNumber;
  final String dateOfJoining; // raw "yyyy-MM-dd" from the API
  final int? departmentId;
  final String designation;
  final String? profileImageUrl; // relative path from the API
  final Department? department;

  const Employee({
    required this.id,
    required this.fullName,
    required this.uniqueEmployeeId,
    required this.email,
    required this.mobileNumber,
    required this.dateOfJoining,
    required this.departmentId,
    required this.designation,
    required this.profileImageUrl,
    required this.department,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    final dept = json['department'];
    return Employee(
      id: parseInt(json['id']) ?? 0,
      fullName: parseString(json['full_name']),
      uniqueEmployeeId: parseString(json['unique_employee_id']),
      email: parseString(json['email']),
      mobileNumber: parseString(json['mobile_number']),
      dateOfJoining: parseString(json['date_of_joining']),
      departmentId: parseInt(json['department_id']),
      designation: parseString(json['designation']),
      profileImageUrl: json['profile_image_url']?.toString(),
      department: dept is Map<String, dynamic> ? Department.fromJson(dept) : null,
    );
  }

  /// Full URL for the avatar, or null if there is no photo.
  String? get imageUrl => ApiConstants.imageUrl(profileImageUrl);

  String get departmentName => department?.name ?? '';

  /// "2026-01-15" -> "15 Jan 2026". Falls back to the raw text if unparseable.
  String get formattedJoiningDate {
    final date = DateTime.tryParse(dateOfJoining);
    if (date == null) return dateOfJoining;
    return DateFormat('dd MMM yyyy').format(date);
  }
}