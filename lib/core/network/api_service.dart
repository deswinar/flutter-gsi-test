import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class ApiService {
  final Dio dio;

  ApiService(this.dio);
}