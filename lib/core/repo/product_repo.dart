import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:salonika/features/home/model/product.dart';

class ProductRepository {
  final DatabaseReference _root = FirebaseDatabase.instance.ref();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  DatabaseReference get _productsRef => _root.child('products');

  // STREAM all products
  Stream<List<Product>> watchProducts() {
    return _productsRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data == null) return <Product>[];
      return data.values.map((raw) {
        final m = Map<String, dynamic>.from(raw as Map);
        return Product.fromJson(m);
      }).toList();
    });
  }

  // Upload image and return its download URL
  Future<String> uploadProductImage(File file, String productId) async {
    final ref = _storage.ref(
      'product_images/$productId/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    final snap = await ref.putFile(file);
    return await snap.ref.getDownloadURL();
  }

  // Create or update product
  Future<void> upsertProduct(Product product) async {
    await _productsRef.child(product.id).set(product.toJson());
  }

  // Favorites
  Stream<bool> favoriteStream(String uid, String productId) {
    return _root
        .child('users/$uid/favorites/$productId')
        .onValue
        .map((e) => (e.snapshot.value == true));
  }

  Future<void> toggleFavorite(String uid, String productId) async {
    final ref = _root.child('users/$uid/favorites/$productId');
    final snap = await ref.get();
    final isFav = snap.value == true;
    await ref.set(!isFav);
  }

  // Cart: increment quantity
  Future<void> addToCart(String uid, String productId, {int qty = 1}) async {
    final ref = _root.child('users/$uid/cart/$productId');
    await ref.runTransaction((current) {
      final cur = (current as Map?) ?? const {};
      final q = (cur['quantity'] ?? 0) as int;
      return Transaction.success({
        'quantity': q + qty,
        'addedAt': ServerValue.timestamp,
      });
    });
  }

  // inside ProductRepository
  Stream<Map<String, Product>> watchProductMap() {
    return _productsRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return <String, Product>{};
      final map = <String, Product>{};
      data.forEach((key, value) {
        map[key.toString()] = Product.fromJson(
          Map<String, dynamic>.from(value as Map),
        );
      });
      return map;
    });
  }

  // in ProductRepository
  Stream<List<Product>> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return watchProducts();
    return watchProducts().map(
      (list) => list.where((p) {
        final name = p.name.toLowerCase();
        final desc = p.description.toLowerCase();
        return name.contains(q) || desc.contains(q);
      }).toList(),
    );
  }
}
