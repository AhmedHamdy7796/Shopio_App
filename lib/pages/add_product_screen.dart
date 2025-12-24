import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/theme/app_theme.dart';
import '../features/home/presentation/cubit/home_cubit.dart';
import '../../features/admin/data/repositories/product_repository_impl.dart';
import '../features/admin/presentation/cubit/add_product_cubit.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return AddProductCubit(
          productRepository: context.read<ProductRepositoryImpl>(),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Product'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<AddProductCubit, AddProductState>(
          listener: (context, state) {
            if (state is AddProductSuccess) {
              context.read<HomeCubit>().addProduct(state.product);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product added successfully!')),
              );
              Navigator.pop(context);
            } else if (state is AddProductFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },

          builder: (context, state) {
            final cubit = context.read<AddProductCubit>();
            return Form(
              key: cubit.formKey,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Details',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        _buildTextField(
                          controller: cubit.titleController,
                          label: 'Title',
                          icon: Icons.title,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 15.h),
                        _buildTextField(
                          controller: cubit.descriptionController,
                          label: 'Description',
                          icon: Icons.description_outlined,
                          maxLines: 3,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: cubit.stockController,
                                label: 'Stock',
                                icon: Icons.inventory_2_outlined,
                                keyboardType: TextInputType.number,
                                validator: (v) =>
                                    v!.isEmpty ? 'Required' : null,
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: _buildTextField(
                                controller: cubit.priceController,
                                label: 'Price',
                                icon: Icons.attach_money,
                                keyboardType: TextInputType.number,
                                validator: (v) =>
                                    v!.isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        _buildTextField(
                          controller: cubit.imageController,
                          label: '',
                          icon: Icons.image_outlined,
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: state is AddProductLoading
                                ? null
                                : cubit.submitProduct,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00E5FF),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                            child: state is AddProductLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.black,
                                  )
                                : Text(
                                    'Submit Product',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, size: 22.sp, color: Colors.black54),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primaryColor),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
      ),
    );
  }
}
