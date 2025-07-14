import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:foriyana_app/data/data_sources/user_local_data_source.dart';
import 'package:foriyana_app/data/models/product_response_model.dart';
import 'package:foriyana_app/domain/repositories/profile_repository.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoaded<T> extends ProductState {
  final List<ProductResponseModel> products;

  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}

class ProductRefresh extends ProductState {
  final List<ProductResponseModel> refreshedProducts;

  ProductRefresh(this.refreshedProducts);
}

class ProductCubit<T> extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  // Method to fetch products (simulated for this example)
  Future<void> fetchProducts() async {
    try {
      emit(ProductInitial()); // Set initial state before fetching data
      String channel = UserLocalDataSource.userData?.channel ?? "";
      var response = await ProfileRepository.getProductCompleted(channel);
      if (response.statusCode == 200) {
        List<ProductResponseModel> res = [];
        response.data.forEach(
          (item) => res.add(ProductResponseModel.fromJson(item)),
        );

        emit(ProductLoaded<T>(res)); // Emit the loaded state with products
      } else {
        emit(
          ProductError('Failed to load products:'),
        ); // Emit error state if the API fails
      }
    } catch (e) {
      emit(
        ProductError('Failed to load products: $e'),
      ); // Emit error state if the API fails
    }
  }
}
