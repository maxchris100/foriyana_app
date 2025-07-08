import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:foriyana_app/data/data_sources/local/user_local_data_source.dart';
import 'package:foriyana_app/data/models/user/commission_response_model.dart';
import 'package:foriyana_app/data/models/user/commission_transactions_response_model.dart';
import 'package:foriyana_app/data/models/user/paging.dart';
import 'package:foriyana_app/data/models/user/product_response_model.dart';
import 'package:foriyana_app/domain/repositories/profile_repository.dart';
import 'package:foriyana_app/env/dev.dart';

//di halaman GWP TEAM DETAILS
@immutable
abstract class CommisionTransactionsState {}

class CommisionTransactionsInitial extends CommisionTransactionsState {}

class CommisionTransactionsLoaded<T> extends CommisionTransactionsState {
  final List<CommisionTransactionsResponseModelData> commisions;

  CommisionTransactionsLoaded(this.commisions);
}

class CommisionTransactionsError extends CommisionTransactionsState {
  final String message;

  CommisionTransactionsError(this.message);
}

class CommisionTransactionsRefresh extends CommisionTransactionsState {
  final List<CommisionTransactionsResponseModelData>
  refreshedCommisionTransactionss;

  CommisionTransactionsRefresh(this.refreshedCommisionTransactionss);
}

class CommisionTransactionsCubit<T> extends Cubit<CommisionTransactionsState> {
  CommisionTransactionsCubit() : super(CommisionTransactionsInitial());
  Paging paging = Paging();
  List<CommisionTransactionsResponseModelData> data = [];

  // Method to fetch commisions (simulated for this example)
  Future<void> fetchCommisionTransactions(
    String startDate,
    String endDate, {
    bool loadMore = false,
  }) async {
    try {
      emit(
        CommisionTransactionsInitial(),
      ); // Set initial state before fetching data
      String channel = DevEnv().publicChannel;

      if (loadMore && paging.isCanNext) {
        paging.setPage(paging.page++);
      }
      var response = await ProfileRepository.getCommissionTransactions(
        channel,
        startDate,
        endDate,
        page: paging.page,
        limit: paging.limit,
      );
      if (response.statusCode == 200) {
        List<CommisionTransactionsResponseModelData> res = [];
        response.data["data"].forEach(
          (item) =>
              res.add(CommisionTransactionsResponseModelData.fromJson(item)),
        );
        int pageTotal = response.data["pageTotal"];
        if (pageTotal > paging.page) {
          //set pagination
          paging.isCanNext = true;
        } else {
          paging.isCanNext = false;
        }

        data.addAll(
          res.where(
            (newItem) =>
                !data.any(
                  (item) => item.transaction?.id == newItem.transaction?.id,
                ),
          ),
        );
        emit(
          CommisionTransactionsLoaded<T>(data),
        ); // Emit the loaded state with commisions
      } else {
        emit(
          CommisionTransactionsError('Failed to load commisions:'),
        ); // Emit error state if the API fails
      }
    } catch (e) {
      emit(
        CommisionTransactionsError('Failed to load commisions: $e'),
      ); // Emit error state if the API fails
    }
  }
}
