import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:keanggotaan/core/network/network_info.dart';
import 'package:keanggotaan/core/network/profile_api_service.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> fetchProfile();
  Future<void> updateProfile(ProfileModel model);
}

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final NetworkInfo networkInfo;
  final ProfileApiService apiService;

  ProfileRemoteDataSourceImpl({
    required this.networkInfo,
    required this.apiService,
  });

  ProfileModel? _mockProfile;

  @override
  Future<ProfileModel> fetchProfile() async {
    print('Mock fetchProfile called');
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final String jsonString =
          await rootBundle.loadString('assets/mocks/get_profile_response.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;

      _mockProfile = ProfileModel.fromJson(jsonMap);
      return _mockProfile!;
    } catch (e) {
      throw Exception('Failed to load mock profile: $e');
    }
  }

  @override
  Future<void> updateProfile(ProfileModel model) async {
    print('Mock updateProfile called with: $model');
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final String jsonString = await rootBundle
          .loadString('assets/mocks/update_profile_response.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;

      final String message = jsonMap['message'] as String? ?? 'No message';
      print('Mock response: $message');

      _mockProfile = model;
    } catch (e) {
      throw Exception('Failed to mock update profile: $e');
    }
  }
}
