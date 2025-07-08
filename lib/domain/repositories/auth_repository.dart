import 'package:dartz/dartz.dart';
import 'package:foriyana_app/domain/entities/auth/auth.dart';
import 'package:foriyana_app/domain/usecases/auth/set_auth_usecase.dart';

import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, Auth>> login(AuthParams params);
}
