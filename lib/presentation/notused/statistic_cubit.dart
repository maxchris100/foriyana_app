import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:foriyana_app/core/util/date_format.dart';
import 'package:foriyana_app/data/data_sources/user_local_data_source.dart';
import 'package:foriyana_app/data/models/statistic_response_model.dart';
import 'package:foriyana_app/domain/repositories/profile_repository.dart';
import 'package:foriyana_app/env/dev.dart';

@immutable
abstract class StatisticState {}

class StatisticInitial extends StatisticState {}

class StatisticLoading extends StatisticState {}

class StatisticLoaded extends StatisticState {
  final StatisticResponseModel? statisticData;

  StatisticLoaded(this.statisticData);
}

class StatisticError extends StatisticState {
  final String message;

  StatisticError(this.message);
}

class StatisticCubit extends Cubit<StatisticState> {
  StatisticCubit() : super(StatisticInitial());

  Future<void> fetchStatisticData(
    DateTime sDate,
    DateTime eDate, {
    String? userChannel,
  }) async {
    try {
      emit(StatisticLoading());
      String channel =
          DevEnv().publicChannel; //UserLocalDataSource.userData?.channel ?? "";
      if (userChannel != null) {
        channel = userChannel;
      }
      String startDate = DateUtil.formatQuery(sDate);
      String endDate = DateUtil.formatQuery(eDate);
      var response = await ProfileRepository.getStatistic(
        channel,
        startDate: startDate,
        endDate: endDate,
      );
      if (response.statusCode == 200) {
        var res = StatisticResponseModel.fromJson(response.data);
        emit(StatisticLoaded(res));
      } else {
        emit(StatisticError("Failed to load statistic"));
      }
    } catch (e) {
      emit(StatisticError("Failed to load StatisticError: $e"));
    }
  }

  Future<void> fetchDownlineStatisticData(
    DateTime sDate,
    DateTime eDate, {
    String? userChannel,
  }) async {
    try {
      emit(StatisticLoading());
      String channel =
          DevEnv().publicChannel; //UserLocalDataSource.userData?.channel ?? "";
      if (userChannel != null) {
        channel = userChannel;
      }
      String startDate = DateUtil.formatQuery(sDate);
      String endDate = DateUtil.formatQuery(eDate);
      var response = await ProfileRepository.getDownlineStatistic(
        channel,
        startDate: startDate,
        endDate: endDate,
      );
      if (response.statusCode == 200) {
        var res = StatisticResponseModel.fromJson(response.data);
        emit(StatisticLoaded(res));
      } else {
        emit(StatisticError("Failed to load statistic"));
      }
    } catch (e) {
      emit(StatisticError("Failed to load StatisticError: $e"));
    }
  }
}
