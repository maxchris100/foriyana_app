import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:foriyana_app/data/data_sources/local/user_local_data_source.dart';
import 'package:foriyana_app/data/models/user/product_plan_response_model.dart';
import 'package:foriyana_app/data/models/user/product_response_model.dart';
import 'package:foriyana_app/domain/repositories/profile_repository.dart';
import 'package:foriyana_app/env/dev.dart';

@immutable
abstract class ProductPlanState {}

class ProductPlanInitial extends ProductPlanState {}

class ProductPlanLoaded<T> extends ProductPlanState {
  final List<ProductPlanResponseModel> productsPlans;

  ProductPlanLoaded(this.productsPlans);
}

class ProductPlanError extends ProductPlanState {
  final String message;

  ProductPlanError(this.message);
}

class ProductPlanRefresh extends ProductPlanState {
  final List<ProductPlanResponseModel> refreshedProductPlans;

  ProductPlanRefresh(this.refreshedProductPlans);
}

class ProductPlanCubit<T> extends Cubit<ProductPlanState> {
  ProductPlanCubit() : super(ProductPlanInitial());

  // Method to fetch productsPlans (simulated for this example)
  Future<void> fetchProductPlans(String productId) async {
    try {
      emit(ProductPlanInitial()); // Set initial state before fetching data
      String channel = DevEnv().publicChannel;
      var response = await ProfileRepository.getProductPlan(channel, productId);
      if (response.statusCode == 200) {
        List<ProductPlanResponseModel> res = [];
        response.data.forEach(
          (item) => res.add(ProductPlanResponseModel.fromJson(item)),
        );

        emit(
          ProductPlanLoaded<T>(res),
        ); // Emit the loaded state with productsPlans
      } else {
        emit(
          ProductPlanError('Failed to load productsPlans:'),
        ); // Emit error state if the API fails
      }
    } catch (e) {
      emit(
        ProductPlanError('Failed to load productsPlans: $e'),
      ); // Emit error state if the API fails
    }
  }
}
