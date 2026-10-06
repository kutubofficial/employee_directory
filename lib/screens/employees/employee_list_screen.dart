import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/view_status.dart';
import '../../models/employee.dart';
import '../../providers/department_provider.dart';
import '../../providers/employee_list_provider.dart';
import '../../widgets/employee_tile.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/error_view.dart';
import '../../widgets/loading_view.dart';
import 'employee_detail_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeListProvider>().load();
      context.read<DepartmentProvider>().load();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      context.read<EmployeeListProvider>().loadMore();
    }
  }

  void _openDetail(Employee e) {
    Navigator.push(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          const SizedBox(height: 12),
          _buildChips(),
          const SizedBox(height: 8),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<EmployeeListProvider>(
      builder: (context, list, _) {
        if (list.status == ViewStatus.error) {
          return ErrorView(
            message: list.errorMessage ?? 'Something went wrong.',
            onRetry: list.load,
          );
        }
        if (list.status == ViewStatus.empty) {
          final filtered = list.search.isNotEmpty || list.departmentId != null;
          return EmptyView(
            message: filtered
                ? 'No employees match your search.'
                : 'No employees found.',
          );
        }
        if (list.employees.isEmpty) return const LoadingView();

        return Column(
          children: [
            if (list.status == ViewStatus.loading)
              const LinearProgressIndicator(minHeight: 2),
            Expanded(
              child: RefreshIndicator(
                onRefresh: list.load,
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: list.employees.length + (list.loadingMore ? 1 : 0),
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 86),
                  itemBuilder: (_, i) {
                    if (i >= list.employees.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }
                    final e = list.employees[i];
                    return EmployeeTile(
                      name: e.fullName,
                      designation: e.designation,
                      department: e.departmentName,
                      imageUrl: e.imageUrl,
                      onTap: () => _openDetail(e),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          const Spacer(),
          const Icon(Icons.change_history_rounded,
              color: AppColors.primary, size: 30),
          const SizedBox(width: 6),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ALOBHA',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1,
                ),
              ),
              Text(
                'Technologies',
                style: TextStyle(fontSize: 9, letterSpacing: 1.2),
              ),
            ],
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
      borderSide: BorderSide.none,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          setState(() {}); // refreshes the clear (x) button
          context.read<EmployeeListProvider>().setSearch(value);
        },
        decoration: InputDecoration(
          hintText: 'Search employees by name, department...',
          hintStyle:
              const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchController.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                    context.read<EmployeeListProvider>().setSearch('');
                  },
                ),
          fillColor: AppColors.chipFill,
          border: border,
          enabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );
  }

  Widget _buildChips() {
    return Consumer2<EmployeeListProvider, DepartmentProvider>(
      builder: (context, list, depts, _) {
        final chips = <({String label, int? id})>[
          (label: 'All', id: null),
          ...depts.departments.map((d) => (label: d.name, id: d.id)),
        ];

        return SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: chips.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final chip = chips[i];
              final selected = list.departmentId == chip.id;
              return GestureDetector(
                onTap: () => list.setDepartment(chip.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.chipFill,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    chip.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: selected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}