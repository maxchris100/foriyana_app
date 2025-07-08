import 'package:dartz/dartz.dart';
import 'package:foriyana_app/data/data_sources/remote/auth_remote_data_source.dart';
import 'package:foriyana_app/data/models/auth/auth_response_model.dart';
import 'package:foriyana_app/domain/entities/auth/auth.dart';
import 'package:foriyana_app/domain/repositories/auth_repository.dart';

import '../../../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../data_sources/local/user_local_data_source.dart';

typedef _DataSourceChooser = Future<AuthResponseModel> Function();

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  Future<Either<Failure, String>> getUserToken() async {
    try {
      final user = await localDataSource.getToken();
      return Right(user);
    } on CacheFailure {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Auth>> login(params) async {
    return await _setToken(() {
      return remoteDataSource.login(params);
    });
  }

  @override
  // ignore: override_on_non_overriding_member
  Future<Either<Failure, Auth>> _setToken(
    // ignore: library_private_types_in_public_api
    _DataSourceChooser getDataSource,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteResponse = await getDataSource();
        localDataSource.saveToken(remoteResponse.token);
        return Right(remoteResponse);
      } on Failure catch (failure) {
        return Left(failure);
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
