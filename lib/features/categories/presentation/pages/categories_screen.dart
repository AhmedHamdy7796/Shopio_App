import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shopio_app/core/routes/app_routes.dart';
import 'package:shopio_app/features/home/presentation/cubit/home_cubit.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  IconData _getCategoryIcon(String slug) {
    if (slug.contains('beauty')) return Icons.face;
    if (slug.contains('fragrance')) return Icons.opacity;
    if (slug.contains('furniture')) return Icons.chair;
    if (slug.contains('groceries')) return Icons.local_grocery_store;
    if (slug.contains('home-decoration')) return Icons.home;
    if (slug.contains('kitchen')) return Icons.kitchen;
    if (slug.contains('laptops')) return Icons.laptop;
    if (slug.contains('mens')) return Icons.man;
    if (slug.contains('womens')) return Icons.woman;
    if (slug.contains('motorcycle')) return Icons.motorcycle;
    if (slug.contains('phone')) return Icons.phone_android;
    if (slug.contains('sunglasses')) return Icons.remove_red_eye;
    if (slug.contains('tops')) return Icons.checkroom;
    if (slug.contains('vehicle')) return Icons.directions_car;
    return Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Categories',
          style: TextStyle(
            color: const Color(0xFF1A1D1E),
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeLoaded) {
            final categories = state.categories;
            if (categories.isEmpty) {
              return Center(child: Text('No categories found'));
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Categories',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      // Assign a random color or specific based on index if needed
                      final color = [
                        const Color(0xFFE3F2FD),
                        const Color(0xFFFCE4EC),
                        const Color(0xFFE8F5E9),
                        const Color(0xFFFFF3E0),
                        const Color(0xFFF3E5F5),
                        const Color(0xFFE0F7FA),
                      ][index % 6];

                      return GestureDetector(
                        onTap: () {
                          // Filter home by this category then go back (or navigation logic)
                          context.read<HomeCubit>().filterByCategory(
                            cat.iconParam,
                          );
                          Navigator.pushNamed(context, Routes.home);
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getCategoryIcon(cat.iconParam),
                                  color: Colors.black87,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                cat.name,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A1D1E),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Tap to view',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 50.ms * index).scale(),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text("Error loading categories"));
        },
      ),
    );
  }
}
