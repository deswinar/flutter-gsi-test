// import 'dart:convert';

// import 'package:flutter_test/flutter_test.dart';
// import 'package:http/http.dart' as http;
// import 'package:keanggotaan/features/auth/data/datasources/auth_remote_datasource.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';


// import 'auth_remote_datasource_test.mocks.dart';

// @GenerateMocks([http.Client])
// void main() {
//   late AuthRemoteDatasourceImpl datasource;
//   late MockClient mockClient;

//   setUp(() {
//     mockClient = MockClient();
//     datasource = AuthRemoteDatasourceImplWithClient(mockClient); // custom class to inject client
//   });

//   group('signIn', () {
//     const email = 'aziz@shariacoin.com';
//     const password = 'aziz123';

//     test('returns token when sign-in is successful', () async {
//       final mockResponse = {
//         "access_token": "abc123",
//         "token_type": "Bearer",
//         "expires_in": 3600
//       };

//       when(mockClient.post(
//         Uri.parse('https://8583z060-8001.asse.devtunnels.ms/api'),
//         headers: anyNamed('headers'),
//         body: anyNamed('body'),
//       )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

//       final result = await datasource.signIn(email, password);

//       expect(result['access_token'], equals('abc123'));
//       expect(result['token_type'], equals('Bearer'));
//       expect(result['expires_in'], equals(3600));
//     });

//     test('throws exception on 422 error', () async {
//       final errorResponse = {"error": "Invalid email or password"};

//       when(mockClient.post(
//         any,
//         headers: anyNamed('headers'),
//         body: anyNamed('body'),
//       )).thenAnswer((_) async => http.Response(jsonEncode(errorResponse), 422));

//       expect(() => datasource.signIn(email, password), throwsA(isA<Exception>()));
//     });

//     test('throws exception on other status codes', () async {
//       when(mockClient.post(
//         any,
//         headers: anyNamed('headers'),
//         body: anyNamed('body'),
//       )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

//       expect(() => datasource.signIn(email, password), throwsA(isA<Exception>()));
//     });
//   });
// }

// /// Subclass to inject custom http client for testing
// class AuthRemoteDatasourceImplWithClient extends AuthRemoteDatasourceImpl {
//   final http.Client _client;

//   AuthRemoteDatasourceImplWithClient(this._client);

//   @override
//   http.Client getClient() => _client;
// }
