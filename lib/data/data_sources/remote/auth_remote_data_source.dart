import 'dart:convert';

import 'package:foriyana_app/core/error/failures.dart';
import 'package:http/http.dart' as http;
import 'package:foriyana_app/data/models/auth/auth_response_model.dart';
import 'package:foriyana_app/domain/usecases/auth/set_auth_usecase.dart';

import '../../../../core/error/exceptions.dart';
import '../../../core/constant/strings.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(AuthParams params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<AuthResponseModel> login(AuthParams params) async {
    final response = await client.post(
      Uri.parse('$baseUrl/authentication/local/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'message': params.message, 'token': params.token}),
    );
    if (response.statusCode == 200) {
      return authResponseModelFromJson(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      throw CredentialFailure();
    } else {
      throw ServerException();
    }
  }
}
