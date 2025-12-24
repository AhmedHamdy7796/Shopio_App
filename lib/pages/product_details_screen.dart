import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../features/home/data/models/product_model.dart';
import '../core/utils/app_assets.dart';
import '../features/product_details/presentation/cubit/product_details_cubit.dart';
import '../features/cart/presentation/cubit/cart_cubit.dart';
import '../features/product_details/presentation/widgets/review_item.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductDetailsCubit()..loadProductDetails(product.id),
      child: ProductDetailsView(product: product),
    );
  }
}

class ProductDetailsView extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final PageController _pageController = PageController();
  bool _isDescriptionExpanded = false;
  int _quantity = 1;
  String _selectedColor = 'Blue';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 350.h,
                    pinned: true,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    leading: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          PageView(
                            controller: _pageController,
                            children: [
                              _buildImagePlaceholder(Colors.blue.shade50),
                              _buildImagePlaceholder(Colors.red.shade50),
                              _buildImagePlaceholder(Colors.green.shade50),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: SmoothPageIndicator(
                              controller: _pageController,
                              count: 3,
                              effect: ExpandingDotsEffect(
                                dotHeight: 8.h,
                                dotWidth: 8.h,
                                activeDotColor: const Color(0xFF0D6EFD),
                                dotColor: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Seller, Rating
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20.r,
                                backgroundColor: Colors.grey.shade200,
                                child: SvgPicture.asset(
                                  AppAssets.avatarPlaceholder,
                                  height: 24.h,
                                ), // Replaced with SVG
                              ),
                              SizedBox(width: 8.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Shopio Store',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      const Icon(
                                        Icons.verified,
                                        size: 14,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Online 12 mins ago',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  'Chat',
                                  style: TextStyle(
                                    color: const Color(0xFF0D6EFD),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),

                          // Title & Price
                          Text(
                            widget.product.title,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1D1E),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 18.h),
                              SizedBox(width: 4.w),
                              Text(
                                '${widget.product.rating} (120 Reviews)',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14.sp,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '\$${widget.product.price}',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0D6EFD),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),

                          // Options (Color/Size)
                          Text(
                            'Select Color',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              _ColorOption(
                                color: Colors.blue,
                                selected: _selectedColor == 'Blue',
                                onTap: () =>
                                    setState(() => _selectedColor = 'Blue'),
                              ),
                              SizedBox(width: 12.w),
                              _ColorOption(
                                color: Colors.red,
                                selected: _selectedColor == 'Red',
                                onTap: () =>
                                    setState(() => _selectedColor = 'Red'),
                              ),
                              SizedBox(width: 12.w),
                              _ColorOption(
                                color: Colors.black,
                                selected: _selectedColor == 'Black',
                                onTap: () =>
                                    setState(() => _selectedColor = 'Black'),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),

                          // Description
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            widget.product.description,
                            maxLines: _isDescriptionExpanded ? null : 3,
                            overflow: _isDescriptionExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF6C757D),
                              fontSize: 14.sp,
                              height: 1.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isDescriptionExpanded =
                                    !_isDescriptionExpanded;
                              });
                            },
                            child: Text(
                              _isDescriptionExpanded
                                  ? 'Read Less'
                                  : 'Read More',
                              style: TextStyle(
                                color: const Color(0xFF0D6EFD),
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),

                          // Reviews Title
                          Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
                            builder: (context, state) {
                              if (state is ProductDetailsLoaded) {
                                return Column(
                                  children: state.reviews
                                      .map((r) => ReviewItem(review: r))
                                      .toList(),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          SizedBox(height: 100.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_quantity > 1) setState(() => _quantity--);
                          },
                          child: const Icon(Icons.remove, size: 20),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          '$_quantity',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: () {
                            setState(() => _quantity++);
                          },
                          child: const Icon(Icons.add, size: 20),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CartCubit>().addToCart(
                          widget.product,
                          _quantity,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to Cart!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D6EFD),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder(Color color) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          height: 200.h,
          width: 200.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(Icons.image, size: 80.h, color: Colors.white),
        ),
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32.h,
        width: 32.h,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected ? Border.all(color: Colors.white, width: 2) : null,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: selected
            ? const Center(
                child: Icon(Icons.check, size: 16, color: Colors.white),
              )
            : null,
      ),
    );
  }
}
