class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final List<String> reviews;
  final List<String> images;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.rating = 4.5,
    this.images = const [],
    this.reviews = const [],
  });
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // The API returns a list of categories, we'll take the first one
    final List<dynamic>? categoriesList = json['categories'] as List<dynamic>?;
    final String categoryName =
        (categoriesList != null && categoriesList.isNotEmpty)
        ? categoriesList.first.toString()
        : (json['category']?.toString() ?? '');

    return ProductModel(
      id: json['id']?.toString() ?? '',
      title: json['name'] ?? json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['coverPictureUrl'] ?? json['thumbnail'] ?? '',
      category: categoryName,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      images:
          (json['productPictures'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': imageUrl,
      'category': category,
      'rating': rating,
      'images': images,
      'reviews': reviews,
    };
  }
}
