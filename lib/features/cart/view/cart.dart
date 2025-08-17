// lib/features/cart/view/cart_details.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salonika/core/repo/cart_repo.dart';
import 'package:salonika/core/repo/product_repo.dart';
import 'package:salonika/features/cart/view/widgets/cart_badge.dart';
import 'package:salonika/features/cart/view/widgets/check_out_page.dart';
import 'package:salonika/features/home/model/product.dart';
import 'package:salonika/features/home/view/widgets/product_details.dart'; // optional for tapping product



class CartDetails extends StatelessWidget {
  const CartDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final productRepo = ProductRepository();
    final cartRepo = CartRepository();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Cart Details", style: TextStyle(fontWeight: FontWeight.w400)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CartBadgeButton(onPressed: () {}),
          ),
        ],
      ),
      body: StreamBuilder<Map<String, Product>>(
        stream: productRepo.watchProductMap(),
        builder: (context, prodSnap) {
          if (!prodSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = prodSnap.data!; // {productId: Product}

          return StreamBuilder<Map<String, int>>(
            stream: cartRepo.watchCart(uid),
            builder: (context, cartSnap) {
              if (!cartSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final cart = cartSnap.data!; // {productId: qty}

              // Build cart lines that have matching products
              final entries = cart.entries
                  .where((e) => products.containsKey(e.key))
                  .map((e) => _CartLine(product: products[e.key]!, qty: e.value))
                  .toList();

              if (entries.isEmpty) {
                return const _EmptyCart();
              }

              final total = entries.fold<double>(0, (sum, line) => sum + line.product.price * line.qty);

              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: entries.length,
                      separatorBuilder: (_, __) => const Divider(thickness: 0.8, color: Colors.grey),
                      itemBuilder: (context, index) {
                        final line = entries[index];
                        return _CartItemTile(
                          line: line,
                          onIncrease: () => cartRepo.add(uid, line.product.id, delta: 1),
                          onDecrease: () => cartRepo.setQty(uid, line.product.id, line.qty - 1),
                          onRemove: () => cartRepo.remove(uid, line.product.id),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProductDetails(product: line.product)),
                          ),
                        );
                      },
                    ),
                  ),

                  // Footer: total + checkout
                  _CartFooter(
                    total: total,
                    onCheckout: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const Checkout()));
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _CartLine {
  final Product product;
  final int qty;
  _CartLine({required this.product, required this.qty});
}

class _CartItemTile extends StatelessWidget {
  final _CartLine line;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _CartItemTile({
    required this.line,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            line.product.imageUrl,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        // Title + price + qty controls
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line.product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text("GHS ${line.product.price.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _QtyButton(icon: Icons.remove, onPressed: onDecrease),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('${line.qty}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    _QtyButton(icon: Icons.add, onPressed: onIncrease),
                  ],
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onRemove,
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _QtyButton({required this.icon, required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: const Color(0xFFE8F5E9), // light green-ish
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Icon(icon, size: 16, color: Colors.green),
      ),
    );
  }
}

class _CartFooter extends StatelessWidget {
  final double total;
  final VoidCallback onCheckout;
  const _CartFooter({required this.total, required this.onCheckout});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text("Total:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("GHS ${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Proceed to Checkout",
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Text('Your cart is empty', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
