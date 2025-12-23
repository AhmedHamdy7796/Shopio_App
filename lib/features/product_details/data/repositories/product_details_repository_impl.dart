import 'package:dartz/dartz.dart';
import 'package:shopio_app/core/errors/failures.dart';
import 'package:shopio_app/core/errors/exceptions.dart';
import 'package:shopio_app/features/home/data/models/product_model.dart';
import 'package:shopio_app/features/product_details/data/datasources/product_details_remote_datasource.dart';
import 'package:shopio_app/features/product_details/domain/repositories/product_details_repository.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource remoteDataSource;

  ProductDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProductModel>> getProductDetails(
    String productId,
  ) async {
    try {
      final response = await remoteDataSource.getProductDetails(productId);
      if (response != null) {
        // Adjust check based on API structure
        // Assuming response is the product JSON directly or wrapped in data
        // For dummyjson it is direct
        return Right(ProductModel.fromJson(response));
      } else {
        return Left(ServerFailure(message: 'Product not found'));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
