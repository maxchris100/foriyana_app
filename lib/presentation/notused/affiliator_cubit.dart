import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:foriyana_app/data/data_sources/user_local_data_source.dart';
import 'package:foriyana_app/data/models/affiliate_response_model.dart';
import 'package:foriyana_app/data/models/paging.dart';
import 'package:foriyana_app/data/models/product_response_model.dart';
import 'package:foriyana_app/domain/repositories/profile_repository.dart';

@immutable
abstract class AffiliatorState {}

class AffiliatorInitial extends AffiliatorState {}

class AffiliatorLoaded<T> extends AffiliatorState {
  final List<AffiliateResponseModelData> affiliates;

  AffiliatorLoaded(this.affiliates);
}

class AffiliatorError extends AffiliatorState {
  final String message;

  AffiliatorError(this.message);
}

class AffiliatorRefresh extends AffiliatorState {
  final List<AffiliateResponseModelData> refreshedAffiliators;

  AffiliatorRefresh(this.refreshedAffiliators);
}

class AffiliatorCubit<T> extends Cubit<AffiliatorState> {
  AffiliatorCubit() : super(AffiliatorInitial());
  Paging paging = Paging(limit: 1);
  List<AffiliateResponseModelData> data = [];

  // Method to fetch affiliates (simulated for this example)
  Future<void> fetchAffiliators({bool loadMore = false}) async {
    try {
      emit(AffiliatorInitial()); // Set initial state before fetching data
      String channel = UserLocalDataSource.userData?.channel ?? "";

      if (loadMore && paging.isCanNext) {
        paging.setPage(paging.page++);
      }
      var response = await ProfileRepository.getDownline(
        channel,
        page: paging.page,
        limit: paging.limit,
      );
      if (response.statusCode == 200) {
        List<AffiliateResponseModelData> res = [];
        (response.data["data"] ?? []).forEach(
          (item) => res.add(AffiliateResponseModelData.fromJson(item)),
        );
        int pageTotal = response.data["pageTotal"];
        if (pageTotal > paging.page) {
          //set pagination
          paging.isCanNext = true;
        } else {
          paging.isCanNext = false;
        }

        data.addAll(
          res.where((newItem) => !data.any((item) => item.id == newItem.id)),
        );
        emit(
          AffiliatorLoaded<T>(data),
        ); // Emit the loaded state with affiliates
      } else {
        emit(
          AffiliatorError('Failed to load affiliates:'),
        ); // Emit error state if the API fails
      }
    } catch (e) {
      emit(
        AffiliatorError('Failed to load affiliates: $e'),
      ); // Emit error state if the API fails
    }
  }
}
