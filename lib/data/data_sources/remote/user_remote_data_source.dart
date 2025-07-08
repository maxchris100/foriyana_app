import 'dart:convert';

import 'package:foriyana_app/core/error/failures.dart';
import 'package:http/http.dart' as http;
import 'package:foriyana_app/data/models/user/agent_contribution_model.dart';
import 'package:foriyana_app/env/config.dart';

import '../../../../core/error/exceptions.dart';
import '../../../core/constant/strings.dart';
import '../../../domain/usecases/user/sign_in_usecase.dart';
import '../../../domain/usecases/user/sign_up_usecase.dart';
import '../../models/user/authentication_response_model.dart';

abstract class UserRemoteDataSource {
  Future<AuthenticationResponseModel> signIn(SignInParams params);
  Future<AuthenticationResponseModel> signUp(SignUpParams params);
  Future<AgentContributonModel> getDataAgentContribution(SignUpParams params);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  UserRemoteDataSourceImpl({required this.client});
  final String publicAgentBaseUrl = '';

  @override
  Future<AuthenticationResponseModel> signIn(SignInParams params) async {
    final response = await client.post(
      Uri.parse('$baseUrl/authentication/local/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'identifier': params.username,
        'password': params.password,
      }),
    );
    if (response.statusCode == 200) {
      return authenticationResponseModelFromJson(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      throw CredentialFailure();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AuthenticationResponseModel> signUp(SignUpParams params) async {
    final response = await client.post(
      Uri.parse('$baseUrl/authentication/local/sign-up'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'firstName': params.firstName,
        'lastName': params.lastName,
        'email': params.email,
        'password': params.password,
      }),
    );
    if (response.statusCode == 201) {
      return authenticationResponseModelFromJson(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      throw CredentialFailure();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AgentContributonModel> getDataAgentContribution(
    SignUpParams params,
  ) async {
    final response = await client.get(
      Uri.parse('$publicAgentBaseUrl/profile'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      return agentContributionModelFromJson(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      throw CredentialFailure();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AgentContributonModel> getProductAgent(SignUpParams params) async {
    final response = await client.get(
      Uri.parse('$publicAgentBaseUrl/profile'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      return agentContributionModelFromJson(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      throw CredentialFailure();
    } else {
      throw ServerException();
    }
  }
}
