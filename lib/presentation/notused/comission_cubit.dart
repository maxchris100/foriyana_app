import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:foriyana_app/data/data_sources/user_local_data_source.dart';
import 'package:foriyana_app/data/models/commission_response_model.dart';
import 'package:foriyana_app/data/models/product_response_model.dart';
import 'package:foriyana_app/domain/repositories/profile_repository.dart';

@immutable
abstract class CommissionState {}

class CommissionInitial extends CommissionState {}

class CommissionLoaded<T> extends CommissionState {
  final List<CommissionResponseModelData> commisions;

  CommissionLoaded(this.commisions);
}

class CommissionError extends CommissionState {
  final String message;

  CommissionError(this.message);
}

class CommissionRefresh extends CommissionState {
  final List<CommissionResponseModelData> refreshedCommissions;

  CommissionRefresh(this.refreshedCommissions);
}

class CommissionCubit<T> extends Cubit<CommissionState> {
  CommissionCubit() : super(CommissionInitial());

  // Method to fetch commisions (simulated for this example)
  Future<void> fetchCommissions() async {
    try {
      emit(CommissionInitial()); // Set initial state before fetching data
      String channel = UserLocalDataSource.userData?.channel ?? "";
      var response = await ProfileRepository.getCommission(channel);
      if (response.statusCode == 200) {
        List<CommissionResponseModelData> res = [];
        response.data["data"].forEach(
          (item) => res.add(CommissionResponseModelData.fromJson(item)),
        );

        emit(CommissionLoaded<T>(res)); // Emit the loaded state with commisions
      } else {
        emit(
          CommissionError('Failed to load commisions:'),
        ); // Emit error state if the API fails
      }
    } catch (e) {
      emit(
        CommissionError('Failed to load commisions: $e'),
      ); // Emit error state if the API fails
    }
  }
}
