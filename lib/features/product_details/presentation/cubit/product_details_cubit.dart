import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  Future<void> loadProductDetails(String productId) async {
    emit(ProductDetailsLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(
      const ProductDetailsLoaded(
        reviews: [
          'Great product! Highly recommended.',
          'Good value for money.',
          'Fast delivery and good quality.',
          'Average, but does the job.',
        ],
      ),
    );
  }

  void addToCart(String productId) {
    // Logic to add to cart (will communicate with CartCubit later)
  }
}
