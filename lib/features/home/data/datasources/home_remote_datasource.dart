import 'dart:developer';

import 'package:shopio_app/core/api/api_consumer.dart';
import 'package:shopio_app/core/api/end_points.dart';

abstract class HomeRemoteDataSource {
  Future<dynamic> getHomeData();
  Future<dynamic> getCategories();
  Future<dynamic> searchProducts(String text);
  Future<dynamic> getProductsByCategory(String categorySlug);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiConsumer apiConsumer;

  HomeRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<dynamic> getHomeData() async {
    final response = await apiConsumer.get(EndPoints.home);
    log("Calling: $response");

    return response;
  }

  @override
  Future<dynamic> getCategories() async {
    final response = await apiConsumer.get(EndPoints.categories);
    return response;
  }

  @override
  Future<dynamic> searchProducts(String text) async {
    final response = await apiConsumer.get(
      EndPoints.productsSearch,
      data: {'q': text},
    );
    return response;
  }

  @override
  Future<dynamic> getProductsByCategory(String categorySlug) async {
    final response = await apiConsumer.get(
      '${EndPoints.products}/category/$categorySlug',
    );
    return response;
  }
}
