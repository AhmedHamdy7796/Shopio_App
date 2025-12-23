class CategoryModel {
  final String id;
  final String name;
  final String iconParam;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconParam,
  });
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? json['slug'] ?? '',
      name: json['name'] ?? '',
      iconParam: json['slug'] ?? '',
    );
  }
}
