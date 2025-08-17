// lib/features/cart/data/cart_repository.dart
import 'package:firebase_database/firebase_database.dart';

class CartRepository {
  final DatabaseReference _root = FirebaseDatabase.instance.ref();
  DatabaseReference _cartRef(String uid) => _root.child('users/$uid/cart');

  Stream<Map<String, int>> watchCart(String uid) {
    return _cartRef(uid).onValue.map((event) {
      final raw = event.snapshot.value;
      if (raw == null) return <String, int>{};
      final data = Map<dynamic, dynamic>.from(raw as Map);
      return data.map((k, v) =>
          MapEntry(k.toString(), (v is Map ? (v['quantity'] as num?) : (v as num?))?.toInt() ?? 0));
    });
  }

  Stream<int> cartCountStream(String uid) => watchCart(uid).map((m) => m.values.fold(0, (a, b) => a + b));

  Future<void> add(String uid, String productId, {int delta = 1}) async {
    final ref = _cartRef(uid).child(productId);
    await ref.update({
      'quantity': ServerValue.increment(delta),
      'addedAt': ServerValue.timestamp,
    });
  }

  Future<void> setQty(String uid, String productId, int qty) async {
    final ref = _cartRef(uid).child(productId);
    if (qty <= 0) {
      await ref.remove();
    } else {
      await ref.update({'quantity': qty, 'addedAt': ServerValue.timestamp});
    }
  }

  Future<void> remove(String uid, String productId) async => _cartRef(uid).child(productId).remove();

  Future<void> clearCart(String uid) async => _cartRef(uid).remove();
}
