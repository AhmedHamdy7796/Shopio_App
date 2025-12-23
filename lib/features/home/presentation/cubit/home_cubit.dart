import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import '../../domain/repositories/home_repository.dart';
import '../../../../core/errors/failures.dart';
import 'package:shopio_app/features/admin/data/repositories/product_repository_impl.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  final ProductRepository productRepository;

  HomeCubit({required this.homeRepository, required this.productRepository})
    : super(HomeInitial());

  List<CategoryModel> _categories = [];
  List<ProductModel> _products = [];

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    final categoriesResult = await homeRepository.getCategories();
    categoriesResult.fold(
      (failure) {
        final message = failure is ServerFailure
            ? failure.message
            : 'Unknown Error';
        debugPrint('Failed to load categories: $message');
      },
      (data) {
        _categories = data;
      },
    );

    final productsResult = await homeRepository.getProducts();
    productsResult.fold(
      (failure) {
        emit(
          HomeError(
            failure is ServerFailure ? failure.message ?? 'Error' : 'Error',
          ),
        );
      },
      (data) {
        _products = data;
        emit(
          HomeLoaded(
            products: _products,
            categories: _categories,
            filteredProducts: _products,
            selectedCategory: 'All',
          ),
        );
      },
    );
  }

  Future<void> filterByCategory(String categoryName) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      if (categoryName == 'All') {
        emit(
          HomeLoaded(
            products: _products,
            categories: _categories,
            filteredProducts: _products,
            selectedCategory: 'All',
          ),
        );
      } else {
        emit(
          HomeLoaded(
            products: _products,
            categories: _categories,
            filteredProducts: currentState.filteredProducts,
            selectedCategory: categoryName,
            isLoading: true,
          ),
        );

        final result = await homeRepository.getProductsByCategory(categoryName);

        result.fold(
          (failure) {
            emit(
              HomeError(
                failure is ServerFailure ? failure.message ?? 'Error' : 'Error',
              ),
            );
          },
          (data) {
            emit(
              HomeLoaded(
                products: _products,
                categories: _categories,
                filteredProducts: data,
                selectedCategory: categoryName,
                isLoading: false,
              ),
            );
          },
        );
      }
    }
  }

  void addProduct(ProductModel product) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final updatedProducts = List<ProductModel>.from(currentState.products)
        ..insert(0, product);

      _products = updatedProducts;

      List<ProductModel> updatedFiltered = currentState.filteredProducts;
      if (currentState.selectedCategory == 'All' ||
          currentState.selectedCategory == product.category) {
        updatedFiltered = List<ProductModel>.from(currentState.filteredProducts)
          ..insert(0, product);
      }

      emit(
        HomeLoaded(
          products: updatedProducts,
          categories: currentState.categories,
          filteredProducts: updatedFiltered,
          selectedCategory: currentState.selectedCategory,
        ),
      );
    }
  }

  Future<void> deleteProduct(String productId) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;

      final updatedProducts = currentState.products
          .where((p) => p.id != productId)
          .toList();

      _products = updatedProducts;

      final updatedFiltered = currentState.filteredProducts
          .where((p) => p.id != productId)
          .toList();

      emit(
        HomeLoaded(
          products: updatedProducts,
          categories: currentState.categories,
          filteredProducts: updatedFiltered,
          selectedCategory: currentState.selectedCategory,
        ),
      );

      try {
        await productRepository.deleteProduct(productId);
      } catch (e) {
        debugPrint('Error deleting product (API): $e');
      }
    }
  }

  Future<void> searchProducts(String text) async {
    emit(HomeLoading());
    final result = await homeRepository.searchProducts(text);
    result.fold(
      (failure) {
        emit(
          HomeError(
            failure is ServerFailure ? failure.message ?? 'Error' : 'Error',
          ),
        );
      },
      (data) {
        _products = data;
        emit(
          HomeLoaded(
            products: _products,
            categories: _categories,
            filteredProducts: _products,
            selectedCategory: 'All',
          ),
        );
      },
    );
  }
}
