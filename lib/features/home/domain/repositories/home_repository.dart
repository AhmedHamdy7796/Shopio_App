import 'package:dartz/dartz.dart';
import 'package:shopio_app/core/errors/failures.dart';
import 'package:shopio_app/features/home/data/models/product_model.dart';
import 'package:shopio_app/features/home/data/models/category_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts();
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, List<ProductModel>>> searchProducts(String text);
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(
    String categorySlug,
  );
}
