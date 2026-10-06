import 'package:dio/dio.dart';
import 'package:employee_directory/core/constants/api_constants.dart';
import 'package:employee_directory/core/storage/token_storage.dart';
import 'package:flutter/foundation.dart';
import 'auth_interceptor.dart';

class DioClient {
  late final Dio dio;
  late final AuthInterceptor authInterceptor;

  DioClient(TokenStorage tokenStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    );

    authInterceptor = AuthInterceptor(tokenStorage);
    dio.interceptors.add(authInterceptor);

    if (kDebugMode) {
      // Bodies and headers are off so passwords and tokens never reach the logs.
      dio.interceptors.add(
        LogInterceptor(requestBody: false, requestHeader: false),
      );
    }
  }
}