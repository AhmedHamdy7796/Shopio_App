import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shopio_app/core/errors/failures.dart';
import 'package:shopio_app/core/errors/exceptions.dart';
import 'package:shopio_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:shopio_app/features/home/domain/repositories/home_repository.dart';
import 'dart:developer' as dev;
import 'package:shopio_app/features/home/data/models/product_model.dart';
import 'package:shopio_app/features/home/data/models/category_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepositoryImpl({required this.homeRemoteDataSource});

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      var response = await homeRemoteDataSource.getHomeData();
      dev.log('Home API Raw Response Type: ${response.runtimeType}');

      if (response is String) {
        dev.log('Home API response is String, decoding...');
        response = jsonDecode(response);
      }

      if (response is Map && response.containsKey('items')) {
        final List<dynamic> data = response['items'];
        dev.log('Home API Items count: ${data.length}');

        try {
          final products = data
              .map((json) => ProductModel.fromJson(json))
              .toList();
          return Right(products);
        } catch (e, stack) {
          dev.log('Error parsing products: $e');
          dev.log('Stack trace: $stack');
          return Left(ServerFailure(message: "Parsing Error: $e"));
        }
      } else {
        dev.log('Invalid API Response: $response');
        return Left(
          ServerFailure(message: "Invalid API Response: missing items"),
        );
      }
    } on ServerException catch (e) {
      dev.log('ServerException in getProducts: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      dev.log('Unexpected Error in getProducts: $e');
      return Left(ServerFailure(message: "Unexpected Error: $e"));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final response = await homeRemoteDataSource.getCategories();
      dev.log('Categories API Response Type: ${response.runtimeType}');
      dev.log('Categories API Response: $response');

      if (response is List) {
        final categories = response
            .map((json) => CategoryModel.fromJson(json))
            .toList();
        return Right(categories);
      } else if (response is Map && response.containsKey('data')) {
        // Handle cases where categories are nested in a 'data' field
        final List<dynamic> data = response['data'];
        final categories = data
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
      dev.log('ServerException in getCategories: ${e.message}');
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      dev.log('Unexpected Error in getCategories: $e');
      return Left(ServerFailure(message: "Unexpected Error: $e"));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> searchProducts(
    String text,
  ) async {
    try {
      final response = await homeRemoteDataSource.searchProducts(text);
      if (response is Map && response.containsKey('items')) {
        final List<dynamic> data = response['items'];
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
      if (response is Map && response.containsKey('items')) {
        final List<dynamic> data = response['items'];
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
