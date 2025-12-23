part of 'add_product_cubit.dart';

abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {
  final ProductModel product;
  AddProductSuccess(this.product);
}

class AddProductFailure extends AddProductState {
  final String message;
  AddProductFailure(this.message);
}
