import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopio_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:shopio_app/features/home/presentation/widgets/home_banner.dart';
import 'package:shopio_app/features/home/presentation/widgets/product_item_widget.dart';
import 'package:shopio_app/core/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, Routes.categories);
      return;
    }
    if (index == 2) {
      Navigator.pushNamed(context, Routes.addProduct);
      return;
    }
    if (index == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inbox feature coming soon!")),
      );
      return;
    }
    if (index == 4) {
      Navigator.pushNamed(context, Routes.profile);
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white, // Removed for Dark Mode
      appBar: AppBar(
        // backgroundColor: Colors.white, // Removed for Dark Mode
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(12.w),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0D6EFD),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: const Center(
              child: Text(
                "S",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Shopio',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Notifications empty")),
              );
            },
            icon: Badge(
              smallSize: 8,
              child: Icon(
                Icons.notifications_none,
                color: const Color(0xFF1A1D1E),
                size: 28.h,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.cart);
            },
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: const Color(0xFF1A1D1E),
              size: 28.h,
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Search feature coming soon!"),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey.shade400),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                'Search for products...',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      height: 50.h,
                      width: 50.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.mic_none, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
            const HomeBanner(),
            SizedBox(height: 24.h),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                String selectedCategory = 'All';
                if (state is HomeLoaded) {
                  selectedCategory = state.selectedCategory;
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      _CategoryChip(
                        label: 'All',
                        isSelected: selectedCategory == 'All',
                        icon: Icons.grid_view,
                        onTap: () =>
                            context.read<HomeCubit>().filterByCategory('All'),
                      ),
                      SizedBox(width: 12.w),
                      // Dynamic Categories
                      // Dynamic Categories
                      if (state is HomeLoaded)
                        ...state.categories.map((category) {
                          return Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: _CategoryChip(
                              label: category.name,
                              isSelected:
                                  selectedCategory == category.iconParam,
                              icon: _getCategoryIcon(category.iconParam),
                              onTap: () => context
                                  .read<HomeCubit>()
                                  .filterByCategory(category.iconParam),
                            ),
                          );
                        }),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trending Now',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1D1E),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.productsList),
                    child: Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF0D6EFD),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              // Remove fixed height constraint for GridView inside Column
              // Use shrinkWrap and physics
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeLoaded) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state.filteredProducts.isEmpty) {
                      return Center(
                        child: Text(
                          "No products found",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                            0.53, // Adjusted to fix overflow (0.65 -> 0.53 gives much more height)
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                      ),
                      itemCount: state.filteredProducts.length,
                      itemBuilder: (context, index) {
                        return ProductItemWidget(
                          product: state.filteredProducts[index],
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () => _onItemTapped(0),
              child: _NavBarItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: _selectedIndex == 0,
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(1),
              child: _NavBarItem(
                icon: Icons.category_outlined,
                label: 'Categories',
                isSelected: _selectedIndex == 1,
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(2),
              child: Container(
                height: 56.h,
                width: 56.h,
                decoration: const BoxDecoration(
                  color: Color(0xFF0D6EFD),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(3),
              child: _NavBarItem(
                icon: Icons.chat_bubble_outline,
                label: 'Inbox',
                isSelected: _selectedIndex == 3,
              ),
            ),
            GestureDetector(
              onTap: () => _onItemTapped(4),
              child: _NavBarItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isSelected: _selectedIndex == 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A1D1E) : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            if (isSelected) ...[
              Icon(icon, color: Colors.white, size: 18.h),
              SizedBox(width: 8.w),
            ],
            if (!isSelected) ...[
              Icon(icon, color: const Color(0xFF0D6EFD), size: 18.h),
              SizedBox(width: 8.w),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF1A1D1E),
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF0D6EFD) : Colors.grey,
          size: 24.h,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: isSelected ? const Color(0xFF0D6EFD) : Colors.grey,
          ),
        ),
      ],
    );
  }
}
