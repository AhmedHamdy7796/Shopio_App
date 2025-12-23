import 'package:dio/dio.dart';
import 'package:shopio_app/features/home/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductModel> addProduct(Map<String, dynamic> productData);
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<ProductModel> addProduct(Map<String, dynamic> productData) async {
    try {
      final response = await dio.post(
        'https://dummyjson.com/products/add',
        data: productData,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProductModel.fromJson(response.data);
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      final response = await dio.delete('https://dummyjson.com/products/$id');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      } else {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}
