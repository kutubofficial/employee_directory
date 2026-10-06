
import 'package:employee_directory/core/utils/json_utils.dart';

class Department {
  final int id;
  final String name;
  final String slug;

  const Department({
    required this.id,
    required this.name,
    this.slug = '',
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: parseInt(json['id']) ?? 0,
      name: parseString(json['name']),
      slug: parseString(json['slug']),
    );
  }
}