import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shopio_app/features/home/data/models/product_model.dart';
import 'package:shopio_app/features/admin/data/repositories/product_repository_impl.dart';
part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final ProductRepository productRepository;

  AddProductCubit({required this.productRepository})
    : super(AddProductInitial());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> submitProduct() async {
    if (formKey.currentState!.validate()) {
      emit(AddProductLoading());
      try {
        final product = ProductModel(
          id: '',
          title: titleController.text,
          description: descriptionController.text,
          price: double.parse(priceController.text),
          imageUrl: imageController.text,
          category: 'New',
        );

        final newProduct = await productRepository.addProduct(product);

        debugPrint('Product Added: ${newProduct.title}');

        emit(AddProductSuccess(newProduct));
      } catch (e) {
        emit(AddProductFailure(e.toString()));
      }
    }
  }

  @override
  Future<void> close() {
    titleController.dispose();
    descriptionController.dispose();
    stockController.dispose();
    priceController.dispose();
    imageController.dispose();
    return super.close();
  }
}
