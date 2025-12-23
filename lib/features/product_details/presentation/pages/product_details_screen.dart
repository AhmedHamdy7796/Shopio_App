import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shopio_app/features/home/data/models/product_model.dart';
import 'package:shopio_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:shopio_app/features/favorites/presentation/cubit/favorites_state.dart';
import 'package:shopio_app/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:shopio_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:shopio_app/features/product_details/presentation/widgets/review_item.dart';
import 'package:shopio_app/features/product_details/domain/repositories/product_details_repository.dart';
import 'package:shopio_app/core/routes/app_routes.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsCubit(
        productDetailsRepository: context.read<ProductDetailsRepository>(),
      )..loadProductDetails(product.id),
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
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushNamed(context, Routes.home);
                            }
                          },
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: BlocBuilder<FavoritesCubit, FavoritesState>(
                            builder: (context, state) {
                              final isFav = context
                                  .read<FavoritesCubit>()
                                  .isFavorite(widget.product.id);
                              return IconButton(
                                icon: Icon(
                                  isFav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFav ? Colors.red : Colors.black,
                                ),
                                onPressed: () {
                                  context.read<FavoritesCubit>().toggleFavorite(
                                    widget.product,
                                  );
                                },
                              );
                            },
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
                            children: widget.product.images.isNotEmpty
                                ? widget.product.images.map((img) {
                                    return Image.network(
                                      img,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              _buildImagePlaceholder(
                                                Colors.grey.shade50,
                                              ),
                                    );
                                  }).toList()
                                : [
                                    widget.product.imageUrl.isNotEmpty
                                        ? Image.network(
                                            widget.product.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    _buildImagePlaceholder(
                                                      Colors.grey.shade50,
                                                    ),
                                          )
                                        : _buildImagePlaceholder(
                                            Colors.blue.shade50,
                                          ),
                                  ],
                          ),
                          if (widget.product.images.length > 1)
                            Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: SmoothPageIndicator(
                                controller: _pageController,
                                count: widget.product.images.length,
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
