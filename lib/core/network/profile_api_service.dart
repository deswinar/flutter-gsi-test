import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:keanggotaan/core/network/api_service.dart';

@lazySingleton
class ProfileApiService extends ApiService {
  ProfileApiService(Dio dio) : super(dio);

  Future<Response> getProfile() {
    try {
      return dio.get('/');
    } on DioException catch (e) {
      throw Exception('Failed to fetch profile: ${e.message}');
    }
  }

  Future<Response> updateProfile({
    required String fullName,
    required String gender,
  }) async {
    try {
      return dio.post('/', data: {
        'full_name': fullName,
        'gender': gender,
      });
    } on DioException  catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    }
  }
}
