import 'package:employee_directory/core/utils/url_launcher_helper.dart';
import 'package:employee_directory/core/utils/view_status.dart';
import 'package:employee_directory/models/department.dart';
import 'package:employee_directory/providers/employee_list_provider.dart';
import 'package:employee_directory/screens/employees/employee_detail_screen.dart';
import 'package:employee_directory/widgets/employee_tile.dart';
import 'package:employee_directory/widgets/empty_view.dart';
import 'package:employee_directory/widgets/error_view.dart';
import 'package:employee_directory/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DepartmentEmployeesScreen extends StatefulWidget {
  final Department department;

  const DepartmentEmployeesScreen({super.key, required this.department});

  @override
  State<DepartmentEmployeesScreen> createState() => _DepartmentEmployeesScreenState();
}

class _DepartmentEmployeesScreenState extends State<DepartmentEmployeesScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final pos = _scrollController.position;
      if (pos.pixels >= pos.maxScrollExtent - 200) {
        context.read<EmployeeListProvider>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.department.name),
      leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      ),
      body: Consumer<EmployeeListProvider>(
        builder: (context, list, _) {
          if (list.status == ViewStatus.error) {
            return ErrorView(
              message: list.errorMessage ?? 'Something went wrong.',
              onRetry: list.load,
            );
          }
          if (list.status == ViewStatus.empty) {
            return EmptyView(
              message: 'No employees in ${widget.department.name} yet.',
              icon: Icons.people_outline,
            );
          }
          if (list.employees.isEmpty) return const LoadingView();

          return RefreshIndicator(
            onRefresh: list.load,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.employees.length + (list.loadingMore ? 1 : 0),
              separatorBuilder: (_, _) => const Divider(height: 1, indent: 86),
              itemBuilder: (_, i) {
                if (i >= list.employees.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final e = list.employees[i];
                return EmployeeTile(
                  name: e.fullName,
                  designation: e.designation,
                  department: e.departmentName,
                  imageUrl: e.imageUrl,
                  onCall: ()=>UrlLauncherHelper.call(context, e.mobileNumber),
                  onMessage: () => UrlLauncherHelper.sms(context, e.mobileNumber),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EmployeeDetailScreen(
                        name: e.fullName,
                        designation: e.designation,
                        department: e.departmentName,
                        employeeId: e.uniqueEmployeeId,
                        email: e.email,
                        mobile: e.mobileNumber,
                        dateOfJoining: e.formattedJoiningDate,
                        imageUrl: e.imageUrl,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}