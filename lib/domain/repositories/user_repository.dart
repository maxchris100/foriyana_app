import 'package:dartz/dartz.dart';
import 'package:foriyana_app/domain/entities/user/agent_contribution.dart';

import '../../../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/user/user.dart';
import '../usecases/user/sign_in_usecase.dart';
import '../usecases/user/sign_up_usecase.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> signIn(SignInParams params);
  Future<Either<Failure, User>> signUp(SignUpParams params);
  Future<Either<Failure, NoParams>> signOut();
  Future<Either<Failure, User>> getCachedUser();
  Future<Either<Failure, User>> getToken();
  Future<Either<Failure, User>> getUserData();
  Future<Either<Failure, String>> getUserContribution(String token);
}
