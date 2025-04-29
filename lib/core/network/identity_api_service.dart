import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:keanggotaan/core/network/api_service.dart';

@lazySingleton
class IdentityApiService extends ApiService {
  IdentityApiService(Dio dio) : super(dio);

  Future<Response> getIdentity() async {
    try {
      return dio.get('/identity');
    } on DioException catch (e) {
      throw Exception('Failed to fetch identity: ${e.message}');
    }
  }

  Future<Response> updateIdentity({
    required String identityId,
    required String identityPhoto,
    required String address,
  }) async {
    try {
      return dio.post('/identity', data: {
        'identity_id': identityId,
        'identity_photo': identityPhoto,
        'address': address,
      });
    } on DioException catch (e) {
      throw Exception('Failed to update identity: ${e.message}');
    }
  }
}
