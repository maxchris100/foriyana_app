import '../../../domain/entities/product/pagination_meta_data.dart';
import '../../../domain/entities/product/product.dart';
import '../../../domain/entities/product/product_response.dart';
import 'pagination_data_model.dart';
import 'product_model.dart';
import 'dart:convert';

ProductAgentResponseModel productAgentResponseModelFromJson(String str) =>
    ProductAgentResponseModel.fromJson(json.decode(str));

String productAgentResponseModelToJson(ProductAgentResponseModel data) =>
    json.encode(data.toJson());

class ProductAgentResponseModel extends ProductResponse {
  ProductAgentResponseModel({
    required PaginationMetaData meta,
    required List<Product> data,
  }) : super(products: data, paginationMetaData: meta);

  factory ProductAgentResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductAgentResponseModel(
      meta: PaginationMetaDataModel.fromJson(json["meta"]),
      data: List<ProductModel>.from(
          json["data"].map((x) => ProductModel.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "meta": (paginationMetaData as PaginationMetaDataModel).toJson(),
        "data": List<dynamic>.from(
            (products as List<ProductModel>).map((x) => x.toJson())),
      };
}
