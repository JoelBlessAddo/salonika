class Product {
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String quantity;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.quantity,
  });

  @override
  String toString() {
    return 'Product{name: $name, price: $price, imageUrl: $imageUrl, description: $description quantity: $quantity}';
  }
}
