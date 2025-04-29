import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:keanggotaan/core/network/api_service.dart';
import 'package:keanggotaan/core/network/identity_api_service.dart';
import 'package:keanggotaan/core/network/network_info.dart';
import '../models/identity_model.dart';

abstract class IdentityRemoteDataSource {
  Future<IdentityModel> fetchIdentity();
  Future<void> updateIdentity(IdentityModel model);
}

@LazySingleton(as: IdentityRemoteDataSource)
class IdentityRemoteDataSourceImpl implements IdentityRemoteDataSource {
  final NetworkInfo networkInfo;
  final IdentityApiService apiService;

  IdentityRemoteDataSourceImpl({
    required this.networkInfo,
    required this.apiService,
  });

  IdentityModel? _mockIdentity = IdentityModel(
    identityId: '1234123412341234', // mock KTP
    identityPhoto: 'https://picsum.photos/400.webp',
    address: 'Jl. Mawar No. 10, Jakarta',
  );

  // @override
  // Future<IdentityModel> fetchIdentity() async {
  //   if (await networkInfo.isConnected) {
  //     final response = await apiService.getIdentity();
  //     return IdentityModel.fromJson(response.data as Map<String, dynamic>);
  //   } else {
  //     throw Exception('No internet connection');
  //   }
  // }

  // @override
  // Future<void> updateIdentity(IdentityModel model) async {
  //   if (await networkInfo.isConnected) {
  //     await apiService.updateIdentity(
  //       identityId: model.identityId,
  //       identityPhoto: model.identityPhoto,
  //       address: model.address,
  //     );
  //   } else {
  //     throw Exception('No internet connection');
  //   }
  // }

  @override
  Future<IdentityModel> fetchIdentity() async {
    print('Fetching mock identity data');
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    try {
      // Load the JSON from the assets
      final String jsonString = await rootBundle.loadString('assets/mocks/get_identity_response.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;

      // Parse the JSON into an IdentityModel
      return IdentityModel.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Failed to load mock identity data: $e');
    }
  }

  @override
  Future<void> updateIdentity(IdentityModel model) async {
    print('Mock updateIdentity called with: $model');
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay

    try {
      // Load mock response from JSON asset
      final String jsonString = await rootBundle.loadString('assets/mocks/update_identity_response.json');
      final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;

      // log or return the message
      final String message = jsonMap['message']?.toString() ?? 'No message found';
      print('Mock response: $message');

      // Update the mock identity
      _mockIdentity = model;
    } catch (e) {
      throw Exception('Failed to load mock update response: $e');
    }
  }
}
