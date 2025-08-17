// lib/features/home/view/widgets/product_details.dart
// ignore_for_file: deprecated_member_use
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:salonika/core/repo/cart_repo.dart';
import 'package:salonika/core/repo/product_repo.dart';
import 'package:salonika/features/home/model/product.dart';
import 'package:salonika/features/cart/view/cart.dart';
import 'package:salonika/features/home/view/widgets/color_selector.dart';
import 'package:salonika/features/home/view/widgets/product_image.dart';
import 'package:salonika/features/home/view/widgets/specifications.dart';
import 'package:salonika/utils/auth_guard.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final repo = ProductRepository();

  IconData _iconForSpec(String key) {
    final k = key.toLowerCase();
    if (k.contains('power')) return Icons.power;
    if (k.contains('pto')) return Icons.settings_input_component;
    if (k.contains('gear')) return Icons.settings;
    if (k.contains('cylinder')) return Icons.blur_circular;
    if (k.contains('brake')) return Icons.build;
    if (k.contains('category')) return Icons.category_outlined;
    if (k.contains('implement')) return Icons.handyman;
    return Icons.info_outline;
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final specs = widget.product.specs;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        actions: [
          StreamBuilder<bool>(
            stream: uid == null
                ? Stream<bool>.value(false)
                : repo.favoriteStream(uid, widget.product.id),
            builder: (_, s) {
              final fav = s.data == true;
              return IconButton(
                onPressed: () async {
                  final okUid = uid ?? await ensureSignedIn(context);
                  if (okUid == null) return;
                  await repo.toggleFavorite(okUid, widget.product.id);
                },
                icon: Icon(
                  fav ? Icons.favorite : Icons.favorite_border,
                  color: fav ? Colors.red : Colors.grey,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: NetImage(
                widget.product.imageUrl,
                height: 250,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Available in stock',
                    style: TextStyle(fontSize: 15, color: Colors.green),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    "GHS ${widget.product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Color:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ColorSelector(
                colors: [
                  const Color(0xE5F44336),
                  const Color(0xDF4CAF50),
                  const Color(0xE72195F3),
                  const Color(0xE0FF9900),
                ],
                onColorSelected: (color) {},
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Specifications',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  if (specs.isEmpty)
                    const Text(
                      'No specifications provided.',
                      style: TextStyle(color: Colors.black54),
                    )
                  else
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.6,
                      children: specs.entries.map((e) {
                        return buildSpecCard(
                          _iconForSpec(e.key),
                          e.key,
                          e.value,
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(208, 219, 217, 217),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_checkout,
                      color: Colors.green,
                      size: 28,
                    ),
                    onPressed: () async {
                      final okUid = uid ?? await ensureSignedIn(context);
                      if (okUid == null) return;
                      await CartRepository().add(
                        okUid,
                        widget.product.id,
                        delta: 1,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(child: Text('Item added to cart')),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final okUid = uid ?? await ensureSignedIn(context);
                      if (okUid == null) return;
                      await CartRepository().add(
                        okUid,
                        widget.product.id,
                        delta: 1,
                      );
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CartDetails(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
