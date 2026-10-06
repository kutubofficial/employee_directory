import 'package:employee_directory/models/department.dart';
import 'package:employee_directory/providers/department_provider.dart';
import 'package:employee_directory/providers/employee_list_provider.dart';
import 'package:employee_directory/repositories/employee_repository.dart';
import 'package:employee_directory/screens/departments/department_employees_screen.dart';
import 'package:employee_directory/widgets/empty_view.dart';
import 'package:employee_directory/widgets/error_view.dart';
import 'package:employee_directory/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:employee_directory/core/theme/app_colors.dart';
import 'package:employee_directory/core/utils/view_status.dart';


class DepartmentsScreen extends StatefulWidget {
  const DepartmentsScreen({super.key});

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  
  static const _palette = [
    (Color(0xFFFFF1E0), Color(0xFFE8890C)),
    (Color(0xFFE3F2FD), Color(0xFF1E88E5)),
    (Color(0xFFFDE8E8), Color(0xFFE53935)),
    (Color(0xFFFFF4D6), Color(0xFFF9A825)),
    (Color(0xFFEDE7F6), Color(0xFF7E57C2)),
    (Color(0xFFE0F7FA), Color(0xFF00ACC1)),
    (Color(0xFFFCE4EC), Color(0xFFD81B60)),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepartmentProvider>().load();
    });
  }

  void _open(Department d) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (ctx) => EmployeeListProvider(ctx.read<EmployeeRepository>())..setDepartment(d.id),
          child: DepartmentEmployeesScreen(department: d),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Departments')),
      body: Consumer<DepartmentProvider>(
        builder: (context, depts, _) {
          switch (depts.status) {
            case ViewStatus.error:
              return ErrorView(
                message: depts.errorMessage ?? 'Something went wrong.',
                onRetry: () => depts.load(force: true),
              );
            case ViewStatus.empty:
              return const EmptyView(message: 'No departments found.');
            case ViewStatus.success:
              return RefreshIndicator(
                onRefresh: () => depts.load(force: true),
                child: ListView.separated(
                  itemCount: depts.departments.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, indent: 76),
                  itemBuilder: (_, i) {
                    final d = depts.departments[i];
                    final (bg, fg) = _palette[i % _palette.length];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      leading: Container(
  height: 46,
  width: 46,
  decoration: BoxDecoration(
    color: bg,
    shape: BoxShape.circle,
  ),
  padding: const EdgeInsets.all(10),
  child: Image.asset(
    _departmentImage(d.name),
    fit: BoxFit.contain,
  ),
),
                      title: Text(
                        d.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,color: AppColors.textPrimary,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                      onTap: () => _open(d),
                    );
                  },
                ),
              );
            case ViewStatus.initial:
            case ViewStatus.loading:
              return const LoadingView();
          }
        },
      ),
    );
  }
  String _departmentImage(String name) {
  switch (name.toLowerCase().trim()) {
    case 'administration':
      return 'assets/icons/administrator.png';

    case 'customer support':
      return 'assets/icons/support.png';

    case 'finance':
      return 'assets/icons/finance.png';

    case 'human resources':
      return 'assets/icons/human.png';

    case 'information technology':
      return 'assets/icons/it.png';

    case 'legal':
      return 'assets/icons/legal.png';

    case 'marketing':
      return 'assets/icons/marketing.png';

    case 'sales':
      return 'assets/icons/sales.png';

    default:
      return 'assets/icons/administrator.png';
  }
}
}