import 'package:dio/dio.dart';
import '../constants/app_strings.dart';

Dio createDioClient() {
  final options = BaseOptions(
    baseUrl: "https://api.example.com/",
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      "Accept": "application/json",
    },
  );

  final dio = Dio(options);

  dio.interceptors.add(LogInterceptor(
    responseBody: true,
    requestBody: true,
  ));

  return dio;
}
