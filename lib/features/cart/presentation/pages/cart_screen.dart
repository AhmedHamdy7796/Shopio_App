import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shopio_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shopio_app/features/cart/presentation/widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CartView();
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: TextStyle(
            color: const Color(0xFF1A1D1E),
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartLoaded) {
            if (state.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100.h,
                      color: Colors.grey.shade300,
                    ).animate().scale(),
                    SizedBox(height: 24.h),
                    Text(
                      'Your cart is empty',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1D1E),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Looks like you haven\'t added anything yet.',
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                    SizedBox(height: 32.h),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 16.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: const Text(
                        'Start Shopping',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(24.w),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return CartItemWidget(
                            item: item,
                            onIncrement: () => context
                                .read<CartCubit>()
                                .incrementQuantity(item.product.id),
                            onDecrement: () => context
                                .read<CartCubit>()
                                .decrementQuantity(item.product.id),
                            onRemove: () => context
                                .read<CartCubit>()
                                .removeItem(item.product.id),
                          )
                          .animate()
                          .slideX(
                            duration: 300.ms,
                            begin: 0.1,
                            delay: 50.ms * index,
                          )
                          .fadeIn();
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        'Subtotal',
                        '\$${state.totalAmount.toStringAsFixed(2)}',
                      ),
                      SizedBox(height: 12.h),
                      _buildSummaryRow('Delivery', '\$5.00'), // Mock delivery
                      SizedBox(height: 12.h),
                      _buildSummaryRow('Discount', '-\$0.00', isDiscount: true),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: const Divider(),
                      ),
                      _buildSummaryRow(
                        'Total Cost',
                        '\$${(state.totalAmount + 5).toStringAsFixed(2)}',
                        isTotal: true,
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Checkout feature coming soon!'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Proceed to Checkout',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Icon(Icons.arrow_forward_rounded, size: 20.sp),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? const Color(0xFF1A1D1E) : Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal
                ? const Color(0xFF1A1D1E)
                : isDiscount
                ? Colors.green
                : const Color(0xFF1A1D1E),
          ),
        ),
      ],
    );
  }
}
