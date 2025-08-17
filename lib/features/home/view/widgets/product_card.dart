// lib/features/home/view/widgets/product_card.dart
// ignore_for_file: deprecated_member_use
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salonika/core/repo/cart_repo.dart';
import 'package:salonika/core/repo/product_repo.dart';
import 'package:salonika/features/home/model/product.dart';
import 'package:salonika/features/home/view/widgets/product_details.dart';
import 'package:salonika/features/home/view/widgets/product_image.dart';
import 'package:salonika/utils/auth_guard.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final repo = ProductRepository();
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetails(product: product)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: const Color.fromARGB(128, 0, 0, 0),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            // image + favorite
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Stack(
                children: [
                  SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Image(
                      image: product.imageUrl.startsWith('http')
                          ? NetworkImage(product.imageUrl)
                          : AssetImage(product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.white70,
                      radius: 16,
                      child: StreamBuilder<bool>(
                        stream: uid == null
                            ? Stream<bool>.value(false)
                            : repo.favoriteStream(uid, product.id),
                        builder: (_, s) {
                          final fav = s.data == true;
                          return IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              final okUid =
                                  uid ?? await ensureSignedIn(context);
                              if (okUid == null) return;
                              await repo.toggleFavorite(okUid, product.id);
                            },
                            icon: Icon(
                              fav ? Icons.favorite : Icons.favorite_border,
                              color: fav ? Colors.red : Colors.grey,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "GHS ${product.price.toStringAsFixed(2)}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(237, 68, 159, 71),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () async {
                              final okUid =
                                  uid ?? await ensureSignedIn(context);
                              if (okUid == null) return;
                              await CartRepository().add(
                                okUid,
                                product.id,
                                delta: 1,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Center(
                                      child: Text('Item added to cart'),
                                    ),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
