import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../core/network/dio_client.dart';

@module
abstract class DioModule {
  @lazySingleton
  Dio dioClient() => createDioClient();
}
