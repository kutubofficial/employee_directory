import 'package:employee_directory/core/network/api_client.dart';
import 'package:employee_directory/providers/department_provider.dart';
import 'package:employee_directory/repositories/department_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'core/storage/token_storage.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'repositories/auth_repository.dart';
import 'routes/app_routes.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final TokenStorage _tokenStorage = TokenStorage();
  late final DioClient _dioClient = DioClient(_tokenStorage);
  late final AuthRepository _authRepo = AuthRepository(_dioClient.dio);
  late final AuthProvider _authProvider =
      AuthProvider(_authRepo, _tokenStorage);
  late final GoRouter _router = AppRoutes.create(_authProvider);

  late final DepartmentRepository _departmentRepo =
    DepartmentRepository(_dioClient.dio);

  @override
  void initState() {
    super.initState();
    
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    _dioClient.authInterceptor.onUnauthorized = _authProvider.logout;
  }

  @override
  void dispose() {
    _router.dispose();
    _authProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TokenStorage>.value(value: _tokenStorage),
        Provider<DioClient>.value(value: _dioClient),
        Provider<AuthRepository>.value(value: _authRepo),
        ChangeNotifierProvider<AuthProvider>.value(value: _authProvider),
        Provider<DepartmentRepository>.value(value: _departmentRepo),
        ChangeNotifierProvider<DepartmentProvider>(
        create: (_) => DepartmentProvider(_departmentRepo),
  ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Employee Directory',
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
