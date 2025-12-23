import 'package:dartz/dartz.dart';
import 'package:shopio_app/core/errors/failures.dart';
import 'package:shopio_app/features/home/data/models/product_model.dart';

abstract class ProductDetailsRepository {
  Future<Either<Failure, ProductModel>> getProductDetails(String productId);
}
