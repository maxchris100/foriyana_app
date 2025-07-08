import 'package:dartz/dartz.dart';
import 'package:foriyana_app/domain/entities/auth/auth.dart';
import 'package:foriyana_app/domain/repositories/auth_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';

class SetAuthUsecase implements UseCase<Auth, AuthParams> {
  final AuthRepository repository;
  SetAuthUsecase(this.repository);

  @override
  Future<Either<Failure, Auth>> call(AuthParams params) async {
    return await repository.login(params);
  }
}

class AuthParams {
  final String message;
  final String token;
  const AuthParams({required this.message, required this.token});
}
