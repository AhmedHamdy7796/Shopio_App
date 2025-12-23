import 'package:dartz/dartz.dart';
import 'package:shopio_app/core/errors/failures.dart';
import 'package:shopio_app/core/errors/exceptions.dart';
import 'package:shopio_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:shopio_app/features/home/domain/repositories/home_repository.dart';
import 'package:shopio_app/features/home/data/models/product_model.dart';
import 'package:shopio_app/features/home/data/models/category_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepositoryImpl({required this.homeRemoteDataSource});

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      final response = await homeRemoteDataSource.getHomeData();
      if (response is Map && response.containsKey('products')) {
        final List<dynamic> data = response['products'];
        final products = data
            .map((json) => ProductModel.fromJson(json))
            .toList();
        return Right(products);
      } else {
        return Left(ServerFailure(message: "Invalid API Response"));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final response = await homeRemoteDataSource.getCategories();
      if (response is List) {
        final categories = response
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        return Right(categories);
      } else {
        return Left(
          ServerFailure(
            message:
                "Invalid Categories Response Type: ${response.runtimeType}",
          ),
        );
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: "Unexpected Error: $e"));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> searchProducts(
    String text,
  ) async {
    try {
      final response = await homeRemoteDataSource.searchProducts(text);
      if (response is Map && response.containsKey('products')) {
        final List<dynamic> data = response['products'];
        final products = data
            .map((json) => ProductModel.fromJson(json))
            .toList();
        return Right(products);
      } else {
        return Left(ServerFailure(message: "Invalid Search Response"));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(
    String categorySlug,
  ) async {
    try {
      final response = await homeRemoteDataSource.getProductsByCategory(
        categorySlug,
      );
      if (response is Map && response.containsKey('products')) {
        final List<dynamic> data = response['products'];
        final products = data
            .map((json) => ProductModel.fromJson(json))
            .toList();
        return Right(products);
      } else {
        return Left(ServerFailure(message: "Invalid Category Response"));
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
