import 'package:shopio_app/core/api/api_consumer.dart';
import 'package:shopio_app/core/api/end_points.dart';

abstract class ProductDetailsRemoteDataSource {
  Future<dynamic> getProductDetails(String productId);
}

class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  final ApiConsumer apiConsumer;

  ProductDetailsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<dynamic> getProductDetails(String productId) async {
    final response = await apiConsumer.get("${EndPoints.products}/$productId");
    return response;
  }
}
