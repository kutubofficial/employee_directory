import 'package:employee_directory/core/theme/app_colors.dart';
import 'package:employee_directory/providers/auth_provider.dart';
import 'package:employee_directory/screens/employees/employee_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  // IndexedStack keeps each tab's state (scroll position, search) alive
  static const _pages = <Widget>[
    EmployeeListScreen(),
    _ComingSoon('Departments'),
    _ComingSoon('Favorites'),
    _ComingSoon('More'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: Container(
        height: 68,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
         splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textPrimary,
            selectedFontSize: 14.5,
            unselectedFontSize: 13.5,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.people_rounded,size: 28,), label: 'Employees'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.apartment_rounded,size: 28), label: 'Departments'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.star_border_rounded,size: 28), label: 'Favorites'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_rounded,size: 28), label: 'More'),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  final String title;
  const _ComingSoon(this.title);

  @override
  Widget build(BuildContext context) {
    return Center(
  child: ElevatedButton(
    onPressed: () => context.read<AuthProvider>().logout(),
    child: const Text('Logout'),
  ),
);
  }
}