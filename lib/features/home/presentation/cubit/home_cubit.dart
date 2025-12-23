import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_model.dart';
import 'package:shopio_app/features/admin/data/repositories/product_repository_impl.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  // Mock Data
  final ProductRepository productRepository;

  HomeCubit({required this.productRepository}) : super(HomeInitial());

  final List<CategoryModel> _categories = [
    const CategoryModel(id: '1', name: 'All', iconParam: 'all'),
    const CategoryModel(id: '2', name: 'Shoes', iconParam: 'shoes'),
    const CategoryModel(id: '3', name: 'Electronics', iconParam: 'electronics'),
    const CategoryModel(id: '4', name: 'Clothes', iconParam: 'clothes'),
    const CategoryModel(id: '5', name: 'Watches', iconParam: 'watches'),
  ];

  final List<ProductModel> _products = [
    const ProductModel(
      id: '1',
      title: 'Nike Air Max',
      description: 'Comfortable running shoes.',
      price: 120.0,
      imageUrl: 'assets/images/product1.png',
      category: 'Shoes',
    ),
    const ProductModel(
      id: '2',
      title: 'Apple Watch',
      description: 'Smart watch with health features.',
      price: 350.0,
      imageUrl: 'assets/images/product2.png',
      category: 'Watches',
    ),
    const ProductModel(
      id: '3',
      title: 'Sony Headphones',
      description: 'Noise cancelling headphones.',
      price: 200.0,
      imageUrl: 'assets/images/product3.png',
      category: 'Electronics',
    ),
    const ProductModel(
      id: '4',
      title: 'Cotton T-Shirt',
      description: '100% Cotton soft t-shirt.',
      price: 25.0,
      imageUrl: 'assets/images/product4.png',
      category: 'Clothes',
    ),
    const ProductModel(
      id: '5',
      title: 'Running Sneakers',
      description: 'Great for daily jogging.',
      price: 85.0,
      imageUrl: 'assets/images/product5.png',
      category: 'Shoes',
    ),
  ];

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(
      HomeLoaded(
        products: _products,
        categories: _categories,
        filteredProducts: _products,
        selectedCategory: 'All',
      ),
    );
  }

  void filterByCategory(String categoryName) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      List<ProductModel> filtered;
      if (categoryName == 'All') {
        filtered = currentState.products;
      } else {
        filtered = currentState.products
            .where((p) => p.category == categoryName)
            .toList();
      }
      emit(
        HomeLoaded(
          products: currentState.products,
          categories: currentState.categories,
          filteredProducts: filtered,
          selectedCategory: categoryName,
        ),
      );
    }
  }

  void addProduct(ProductModel product) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final updatedProducts = List<ProductModel>.from(currentState.products)
        ..insert(0, product);

      // Also update filtered if category matches or is All
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

      // Optimistic Update: Remove immediately from UI
      final updatedProducts = currentState.products
          .where((p) => p.id != productId)
          .toList();

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
}
