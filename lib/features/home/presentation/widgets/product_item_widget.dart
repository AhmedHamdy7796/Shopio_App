import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopio_app/core/routes/app_routes.dart';
import '../../presentation/cubit/home_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_cubit.dart';
import '../../../favorites/presentation/cubit/favorites_state.dart';
import '../../../home/data/models/product_model.dart';

class ProductItemWidget extends StatelessWidget {
  final ProductModel product;

  const ProductItemWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.productDetails, arguments: product);
      },
      child: Container(
        width: 160.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: Container(
                    height: 140.h,
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 50.h,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4848),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '-20%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      final isFav = context.read<FavoritesCubit>().isFavorite(
                        product.id,
                      );
                      return GestureDetector(
                        onTap: () {
                          context.read<FavoritesCubit>().toggleFavorite(
                            product,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 16.h,
                            color: isFav ? Colors.red : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          content: const Text(
                            'Are you sure?',
                            style: TextStyle(
                              color: Color(0xFF1A1D1E),
                              fontSize: 16,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                context.read<HomeCubit>().deleteProduct(
                                  product.id,
                                );
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 18.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1D1E),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14.h,
                        color: const Color(0xFFFFC107),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '4.8 (120)',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xFF6C757D),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF6C757D),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD0E1FD),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 18.h,
                          color: const Color(0xFF0D6EFD),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(),
    );
  }
}
