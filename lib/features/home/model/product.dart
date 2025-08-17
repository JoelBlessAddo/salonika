// lib/features/home/model/product.dart
class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final int quantity;
  final int createdAt;
  final int updatedAt;

  /// NEW: key/value specs (e.g., "power": "60 HP")
  final Map<String, String> specs;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.createdAt,
    required this.updatedAt,
    this.specs = const {},
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    int? quantity,
    int? createdAt,
    int? updatedAt,
    Map<String, String>? specs,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      specs: specs ?? this.specs,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final rawSpecs = json['specs'];
    final specs = rawSpecs == null
        ? <String, String>{}
        : Map<String, dynamic>.from(rawSpecs as Map)
            .map((k, v) => MapEntry(k.toString(), v.toString()));

    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
      specs: specs,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'price': price,
        'quantity': quantity,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'specs': specs,
      };
}
