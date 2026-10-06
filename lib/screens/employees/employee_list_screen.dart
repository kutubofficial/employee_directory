import 'package:employee_directory/screens/employees/employee_detail_screen.dart';
import 'package:employee_directory/widgets/employee_tile.dart';
import 'package:flutter/material.dart';
import 'package:employee_directory/core/theme/app_colors.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  int _selectedChip = 0;

  // TODO(api): build chips from the /master departments API
  static const _chips = ['All', 'Management', 'Development', 'Sales'];

  // TODO(api): replace with data from EmployeeProvider
  static const _employees = [
    ('Naveen Kumar', 'Director', 'Management'),
    ('Sandeep Gupta', 'CFO', 'Management'),
    ('Ashish Sharma', 'Project Manager', 'Operations'),
    ('Sheetal Verma', 'HR Manager', 'Human Resource'),
    ('Ravi Kumar', 'Senior Developer', 'Development'),
    ('Gaurav Singh', 'Mobile App Developer', 'Development'),
  ];

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
          Expanded(
            child: ListView.separated(
              itemCount: _employees.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, indent: 86),
              itemBuilder: (_, i) {
                final e = _employees[i];
                return EmployeeTile(
                  onTap: () => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => EmployeeDetailScreen(
      name: e.$1,
      designation: e.$2,
      department: e.$3,
      // TODO(api): real values come from the employee model
      employeeId: 'AT001',
      email: 'sample@alobhatechnologies.com',
      mobile: '+91 98765 43210',
      dateOfJoining: '15 Jan 2023',
    ),
  ),
),
                  name: e.$1,
                  designation: e.$2,
                  department: e.$3,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu,color: AppColors.textPrimary,)),
          const Spacer(),
          const Icon(Icons.change_history_rounded,
              color: AppColors.primary, size: 38),
          const SizedBox(width: 6),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ALOBHA',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1,
                ),
              ),
              Text(
                'Technologies',
                style: TextStyle(fontSize: 12, letterSpacing: 1.2,fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search,color: AppColors.textPrimary,size: 26,)),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: AppColors.primary,size: 26,),
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
        readOnly: true, // TODO: open the search screen on tap
        decoration: InputDecoration(
          hintText: 'Search employees by name, department...',
          hintStyle: const TextStyle(
              fontSize: 14, color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          fillColor: AppColors.chipFill,
          border: border,
          enabledBorder: border,
          focusedBorder: border,
        ),
      ),
    );
  }

  Widget _buildChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final selected = i == _selectedChip;
          return GestureDetector(
            onTap: () => setState(() => _selectedChip = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.chipFill,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _chips[i],
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}