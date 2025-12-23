part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> items;
  final double totalAmount;

  const CartLoaded({required this.items, required this.totalAmount});

  @override
  List<Object> get props => [items, totalAmount]; // Using props correctly usually requires copying lists or deep compare, mostly ignoring for simple mock
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}
