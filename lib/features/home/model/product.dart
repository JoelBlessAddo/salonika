import 'package:firebase_database/firebase_database.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;     // now a network URL
  final String description;
  final int quantity;        // stock quantity

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'] as String,
        description: json['description'] as String,
        quantity: (json['quantity'] as num).toInt(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'description': description,
        'quantity': quantity,
        'updatedAt': ServerValue.timestamp,
      };
}
