import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../entities/user/user.dart';
import '../../repositories/user_repository.dart';

class GetUserData implements UseCase<User, NoParams> {
  final UserRepository repository;
  GetUserData(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getUserData();
  }
}

class AgentContributionUseCase implements UseCase<String, String> {
  // ✅ Accepts a String
  final UserRepository repository;
  AgentContributionUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String token) async {
    // ✅ Uses token
    return await repository.getUserContribution(token);
  }
}
