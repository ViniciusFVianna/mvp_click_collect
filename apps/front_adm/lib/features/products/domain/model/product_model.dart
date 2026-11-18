import '../../../../share/base/model.dart';

class ProductModel implements Model {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final bool active;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    this.active = true,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      category: map['category']?.toString() ?? '',
      imageUrl: map['image_url']?.toString() ??
          map['imageUrl']?.toString() ??
          '',
      active: map['active'] as bool? ?? true,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      ProductModel.fromMap(json);

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'image_url': imageUrl,
        'active': active,
      };

  Map<String, dynamic> toJson() => toMap();
}
