part of 'product_details_cubit.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  final List<String> reviews; // Mocking reviews as strings for simplicity

  const ProductDetailsLoaded({required this.reviews});

  @override
  List<Object> get props => [reviews];
}
