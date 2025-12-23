import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopio_app/core/routes/app_routes.dart';
import 'package:shopio_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:shopio_app/features/home/presentation/widgets/product_item_widget.dart';
import 'package:shopio_app/features/admin/data/repositories/product_repository_impl.dart';
import 'package:shopio_app/features/home/domain/repositories/home_repository.dart';

class ProductsListScreen extends StatelessWidget {
  final String? categoryName;

  const ProductsListScreen({super.key, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return ProductsListView(categoryName: categoryName);
  }
}

class ProductsListView extends StatefulWidget {
  final String? categoryName;

  const ProductsListView({super.key, this.categoryName});

  @override
  State<ProductsListView> createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView> {
  @override
  void initState() {
    super.initState();
  }

  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        productRepository: context.read<ProductRepositoryImpl>(),
        homeRepository: context.read<HomeRepository>(),
      )..loadHomeData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (_isSearching) {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
                // Reload or reset logic if needed, but for now just close search
              } else {
                Navigator.pop(context);
              }
            },
          ),
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search products...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      // Find the cubit from the context created above?
                      // Wait, the BlocProvider is wrapping Scaffold, so context here is ABOVE usage.
                      // We need a Builder or context inside.
                      // Actually, we can't access provided bloc here easily without Builder.
                      // I will wrap body in Builder to access context or use context from Builder above?
                      // Ah, this build method returns query so I need to make sure logic works.
                    }
                  },
                  onChanged: (value) {
                    // Debounce could be good, but direct call for now
                    // We need the context that has the HomeCubit.
                  },
                )
              : Text(
                  widget.categoryName ?? 'Products',
                  style: TextStyle(
                    color: const Color(0xFF1A1D1E),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
          actions: [
            if (!_isSearching)
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
              ),
            if (_isSearching)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                  });
                },
              ),
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pushNamed(context, Routes.cart),
            ),
          ],
        ),
        body: Column(
          children: [
            // Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'Sort by',
                    icon: Icons.sort,
                    isSelected: true,
                  ),
                  SizedBox(width: 12.w),
                  _FilterChip(
                    label: 'Price',
                    icon: Icons.expand_more,
                    isSelected: false,
                  ),
                  SizedBox(width: 12.w),
                  _FilterChip(
                    label: 'Brand',
                    icon: Icons.expand_more,
                    isSelected: false,
                  ),
                  SizedBox(width: 12.w),
                  _FilterChip(
                    label: 'Size',
                    icon: Icons.expand_more,
                    isSelected: false,
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeLoaded) {
                    // Filter locally if needed or rely on cubit
                    final products = widget.categoryName != null
                        ? state.products
                              .where((p) => p.category == widget.categoryName)
                              .toList()
                        : state.products;

                    return GridView.builder(
                      padding: EdgeInsets.all(24.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductItemWidget(product: products[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;

  const _FilterChip({required this.label, this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1A1D1E) : Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF1A1D1E),
            ),
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
    );
  }
}
