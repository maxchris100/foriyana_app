import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:foriyana_app/data/data_sources/user_local_data_source.dart';
import 'package:foriyana_app/data/models/product_hotlead_response_model.dart';
import 'package:foriyana_app/data/models/product_response_model.dart';
import 'package:foriyana_app/domain/repositories/profile_repository.dart';
import 'package:foriyana_app/env/dev.dart';
import 'package:foriyana_app/env/env.dart';

@immutable
abstract class ProductHotleadState {}

class ProductHotleadInitial extends ProductHotleadState {}

class ProductHotleadLoaded<T> extends ProductHotleadState {
  final List<ProductHotleadResponseModelData> products;
  final ProductHotleadStatisticResponseModel statistic;

  ProductHotleadLoaded(this.products, this.statistic);
}

class ProductHotleadError extends ProductHotleadState {
  final String message;

  ProductHotleadError(this.message);
}

class ProductHotleadRefresh extends ProductHotleadState {
  final List<ProductHotleadResponseModel> refreshedProductHotleads;

  ProductHotleadRefresh(this.refreshedProductHotleads);
}

class ProductHotleadCubit<T> extends Cubit<ProductHotleadState> {
  ProductHotleadCubit() : super(ProductHotleadInitial());

  // Method to fetch products (simulated for this example)
  Future<void> fetchProductHotleads(String products, String filter) async {
    try {
      emit(ProductHotleadInitial()); // Set initial state before fetching data
      String channel = DevEnv().publicChannel;
      var response = await ProfileRepository.getProductHotLeads(
        channel,
        products,
        filter: filter,
      );
      if (response.statusCode == 200) {
        List<ProductHotleadResponseModelData> res = [];
        response.data["data"].forEach(
          (item) => res.add(ProductHotleadResponseModelData.fromJson(item)),
        );
        ProductHotleadStatisticResponseModel resStatistic =
            ProductHotleadStatisticResponseModel.fromJson(
          response.data["statistic"],
        );
        emit(
          ProductHotleadLoaded<T>(res, resStatistic),
        ); // Emit the loaded state with products
      } else {
        emit(
          ProductHotleadError('Failed to load products:'),
        ); // Emit error state if the API fails
      }
    } catch (e) {
      emit(
        ProductHotleadError('Failed to load products: $e'),
      ); // Emit error state if the API fails
    }
  }
}
