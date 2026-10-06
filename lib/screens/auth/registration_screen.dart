import 'dart:io';

import 'package:employee_directory/core/theme/app_colors.dart';
import 'package:employee_directory/core/utils/validators.dart';
import 'package:employee_directory/core/utils/view_status.dart';
import 'package:employee_directory/providers/auth_provider.dart';
import 'package:employee_directory/providers/department_provider.dart';
import 'package:employee_directory/routes/app_routes.dart';
import 'package:employee_directory/widgets/app_button.dart';
import 'package:employee_directory/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _designationController = TextEditingController();
  final _dateController = TextEditingController();
  final _passwordController = TextEditingController();

  File? _profileImage;
  int? _departmentId;
  DateTime? _joiningDate;

  @override
  void initState() {
    super.initState();
    // Load departments after the first frame so notifyListeners is safe.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepartmentProvider>().load();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _employeeIdController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _designationController.dispose();
    _dateController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _joiningDate ?? now,
      firstDate: DateTime(now.year - 40),
      lastDate: DateTime(now.year + 1),
    );
    if (date == null) return;
    setState(() {
      _joiningDate = date;
      _dateController.text = DateFormat('dd MMM yyyy').format(date);
    });
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (_profileImage == null) {
      _showMessage('Please select a profile photo');
      return;
    }

    FocusScope.of(context).unfocus();

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      fullName: _fullNameController.text,
      employeeId: _employeeIdController.text,
      email: _emailController.text,
      mobileNumber: _mobileController.text,
      password: _passwordController.text,
      dateOfJoining: DateFormat('yyyy-MM-dd').format(_joiningDate!),
      departmentId: _departmentId!,
      designation: _designationController.text,
      imagePath: _profileImage!.path,
    );

    if (!mounted) return;

    if (success) {
      _showMessage('Registration successful. Please log in.');
      context.go(AppRoutes.login);
    } else {
      _showMessage(auth.errorMessage ?? 'Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back button
                  Row(
                    children: [
                      IconButton(
                        onPressed: _goToLogin,
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 21,
                          color: AppColors.textPrimary,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
          
                  const SizedBox(height: 2),
          
                  // Title
                  const Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
          
                  const SizedBox(height: 2),
          
                  const Text(
                    'Join your company directory',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondary,
                    ),
                  ),
          
                  const SizedBox(height: 18),
          
                  // Profile image
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 112,
                            width: 112,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFE5E7EB),
                              border: Border.all(
                                color: const Color(0xFFBFC3C7),
                                width: 1.5,
                              ),
                            ),
                            child: ClipOval(
                              child: _profileImage != null
                                  ? Image.file(
                                      _profileImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 62,
                                      color: Color(0xFF7A7F85),
                                    ),
                            ),
                          ),
          
                          // Camera button
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          
                  const SizedBox(height: 22),
          
                  // Full Name
                  AppTextField(
                    label: 'Full Name',
                    controller: _fullNameController,
                    prefixIcon: Icons.person_outline,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
          
                  const SizedBox(height: 10),
          
                  // Employee ID
                  AppTextField(
                    label: 'Employee ID',
                    controller: _employeeIdController,
                    prefixIcon: Icons.badge_outlined,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter employee ID';
                      }
                      return null;
                    },
                  ),
          
                  const SizedBox(height: 10),
          
                  // Email
                  AppTextField(
                    label: 'Email Address',
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: Validators.email,
                  ),
          
                  const SizedBox(height: 10),
          
                  // Mobile
                  AppTextField(
                    label: 'Mobile Number',
                    controller: _mobileController,
                    prefixIcon: Icons.phone_android_outlined,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter mobile number';
                      }
          
                      if (value.length < 10) {
                        return 'Please enter a valid mobile number';
                      }
          
                      return null;
                    },
                  ),
          
                  const SizedBox(height: 10),
          
                  // Department (loaded from the API)
                  _buildDepartmentField(),
          
                  const SizedBox(height: 10),
          
                  // Designation
                  AppTextField(
                    label: 'Designation',
                    controller: _designationController,
                    prefixIcon: Icons.work_outline,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter designation';
                      }
                      return null;
                    },
                  ),
          
                  const SizedBox(height: 10),
          
                  // Date of joining
                  TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _pickDate,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select date of joining';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Date of Joining',
                      prefixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                  ),
          
                  const SizedBox(height: 10),
          
                  // Password
                  AppTextField(
                    label: 'Password',
                    controller: _passwordController,
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    validator: Validators.password,
                  ),
          
                  const SizedBox(height: 30),
          
                  // Register button
                  SizedBox(
                    height: 48,
                    child: AppButton(
                      label: 'Register',
                      isLoading:
                          context.select<AuthProvider, bool>((p) => p.isLoading),
                      onPressed: _onRegister,
                    ),
                  ),
          
                  const SizedBox(height: 25),
          
                  // Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: _goToLogin,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
          
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDepartmentField() {
    final depts = context.watch<DepartmentProvider>();

    if (depts.status == ViewStatus.error) {
      return Row(
        children: [
          Expanded(
            child: Text(
              depts.errorMessage ?? 'Could not load departments',
              style: const TextStyle(color: AppColors.error),
            ),
          ),
          TextButton(
            onPressed: () => depts.load(force: true),
            child: const Text('Retry'),
          ),
        ],
      );
    }

    final loading = depts.status == ViewStatus.loading ||
        depts.status == ViewStatus.initial;

    return DropdownButtonFormField<int>(
      initialValue: _departmentId,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: loading ? 'Loading departments...' : 'Department',
        prefixIcon: const Icon(Icons.apartment),
      ),
      items: depts.departments
          .map((d) => DropdownMenuItem(value: d.id, child: Text(d.name)))
          .toList(),
      onChanged: loading ? null : (v) => setState(() => _departmentId = v),
      validator: (v) => v == null ? 'Select a department' : null,
    );
  }
}