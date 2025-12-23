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

  const HomeLoaded({
    required this.products,
    required this.categories,
    required this.filteredProducts,
    this.selectedCategory = 'All',
  });

  @override
  List<Object> get props => [
    products,
    categories,
    filteredProducts,
    selectedCategory,
  ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
