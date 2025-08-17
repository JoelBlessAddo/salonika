// lib/features/orders/data/order_repository.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:salonika/features/home/model/product.dart';

class OrderRepository {
  final DatabaseReference _root = FirebaseDatabase.instance.ref();

  DatabaseReference _ordersRef(String uid) => _root.child('users/$uid/orders');

  Future<String> placeOrder(
    String uid, {
    required Map<String, int> cart,                // {productId: qty}
    required Map<String, Product> products,        // {productId: Product}
    required String name,
    required String address,
    required String phone,
    required String paymentMethod,                 // e.g. "creditCard", "mobileMoney"
  }) async {
    // Build items & totals
    final items = <Map<String, dynamic>>[];
    int totalQty = 0;
    double subTotal = 0;

    cart.forEach((productId, qty) {
      final p = products[productId];
      if (p == null || qty <= 0) return;
      final line = {
        'productId': p.id,
        'name': p.name,
        'price': p.price,
        'qty': qty,
        'imageUrl': p.imageUrl,
        'subtotal': double.parse((p.price * qty).toStringAsFixed(2)),
      };
      items.add(line);
      totalQty += qty;
      subTotal += p.price * qty;
    });

    final shippingFee = 0.0; // change if you want dynamic shipping
    final grandTotal = double.parse((subTotal + shippingFee).toStringAsFixed(2));

    // Create order node
    final orderRef = _ordersRef(uid).push();
    final orderId = orderRef.key!;
    await orderRef.set({
      'orderId': orderId,
      'status': 'pending', // pending -> processing -> shipped -> delivered
      'createdAt': ServerValue.timestamp,
      'paymentMethod': paymentMethod,
      'shipping': {
        'name': name,
        'address': address,
        'phone': phone,
      },
      'items': items,
      'summary': {
        'totalQty': totalQty,
        'subTotal': double.parse(subTotal.toStringAsFixed(2)),
        'shippingFee': shippingFee,
        'grandTotal': grandTotal,
      },
    });

    // Clear cart after successful order
    await _root.child('users/$uid/cart').remove();

    return orderId;
  }

  Stream<Map<String, dynamic>?> watchOrder(String uid, String orderId) {
    return _ordersRef(uid).child(orderId).onValue.map((e) {
      final v = e.snapshot.value;
      if (v == null) return null;
      return Map<String, dynamic>.from(v as Map);
    });
  }
}
