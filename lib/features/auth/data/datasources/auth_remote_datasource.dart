import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:keanggotaan/core/network/dio_client.dart';

abstract class AuthRemoteDatasource {
  Future<Map<String, dynamic>> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> resetPassword(String email);
  Future<void> signOut();
}

@LazySingleton(as: AuthRemoteDatasource)
class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio = createDioClient();
  final _signInEndpoint = 'https://8583z060-8001.asse.devtunnels.ms/api';

  @override
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    print('SignIn request: email=$email, password=$password');
    try {
      final response = await _dio.post(
        _signInEndpoint,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
        data: {
          'email': email,
          'password': password,
        },
      );

      print('SignIn response: ${response.statusCode} ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        return {
          'access_token': data['access_token'],
          'token_type': data['token_type'],
          'expires_in': data['expires_in'],
        };
      } else {
        throw Exception('Sign-in failed: ${response.statusCode} ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 422) {
        throw Exception('Validation failed: ${e.response?.data}');
      } else {
        print('DioException: ${e.message}');
        rethrow;
      }
    } catch (e) {
      print('Exception during signIn: $e');
      rethrow;
    }
  }

  // Mock data
  // @override
  // Future<Map<String, dynamic>> signIn(String email, String password) async {
  //   print('Mock SignIn: email=$email, password=$password');
  //   await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

  //   if (email == 'aziz@shariacoin.com' && password == 'aziz123') {
  //     return {
  //       'access_token': 'mock-access-token',
  //       'token_type': 'Bearer',
  //       'expires_in': 3600,
  //     };
  //   } else {
  //     throw Exception('Invalid email or password');
  //   }
  // }

  @override
  Future<void> signUp(String email, String password) async {
    // To be implemented with real endpoint later
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
