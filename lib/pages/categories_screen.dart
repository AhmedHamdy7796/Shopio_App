import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/routes/app_routes.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Fashion',
        'icon': Icons.checkroom,
        'color': const Color(0xFFE3F2FD),
        'items': 120,
      },
      {
        'name': 'Electronics',
        'icon': Icons.devices,
        'color': const Color(0xFFFCE4EC),
        'items': 58,
      },
      {
        'name': 'Home',
        'icon': Icons.chair_outlined,
        'color': const Color(0xFFE8F5E9),
        'items': 45,
      },
      {
        'name': 'Beauty',
        'icon': Icons.face,
        'color': const Color(0xFFFFF3E0),
        'items': 89,
      },
      {
        'name': 'Sports',
        'icon': Icons.sports_basketball,
        'color': const Color(0xFFF3E5F5),
        'items': 32,
      },
      {
        'name': 'Books',
        'icon': Icons.menu_book,
        'color': const Color(0xFFE0F7FA),
        'items': 67,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        title: Text(
          'Categories',
          style: TextStyle(
            color: const Color(0xFF1A1D1E),
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            color: Colors.black,
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Categories',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
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
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.productsList,
                      arguments: cat['name'],
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: cat['color'],
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
                          child: Icon(cat['icon'], color: Colors.black87),
                        ),
                        const Spacer(),
                        Text(
                          cat['name'],
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1D1E),
                          ),
                        ),
                        Text(
                          '${cat['items']} items',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 100.ms * index).scale(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
