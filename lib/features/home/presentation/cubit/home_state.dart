part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final List<ProductModel> filteredProducts;
  final String selectedCategory;
  final bool isLoading;

  const HomeLoaded({
    required this.products,
    required this.categories,
    required this.filteredProducts,
    this.selectedCategory = 'All',
    this.isLoading = false,
  });

  @override
  List<Object> get props => [
    products,
    categories,
    filteredProducts,
    selectedCategory,
    isLoading,
  ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
