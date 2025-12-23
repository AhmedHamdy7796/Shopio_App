import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/product_details_repository.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductDetailsRepository productDetailsRepository;

  ProductDetailsCubit({required this.productDetailsRepository})
    : super(ProductDetailsInitial());

  Future<void> loadProductDetails(String productId) async {
    emit(ProductDetailsLoading());
    final result = await productDetailsRepository.getProductDetails(productId);
    result.fold(
      (failure) => emit(
        ProductDetailsError(
          failure is ServerFailure ? failure.message ?? 'Error' : 'Error',
        ),
      ),
      (product) => emit(ProductDetailsLoaded(reviews: product.reviews)),
    );
  }

  void addToCart(String productId) {
    // Logic to add to cart (will communicate with CartCubit later)
  }
}
