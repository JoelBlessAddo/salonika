// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salonika/core/repo/cart_repo.dart';
import 'package:salonika/core/repo/product_repo.dart';
import 'package:salonika/features/home/model/product.dart';
import 'package:salonika/features/home/view/widgets/product_details.dart';
import 'package:salonika/utils/colors.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final repo = ProductRepository();

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
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl), // <-- network
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Colors.white70,
                    radius: 16,
                    child: StreamBuilder<bool>(
                      stream: repo.favoriteStream(uid, product.id),
                      builder: (_, s) {
                        final fav = s.data == true;
                        return IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => repo.toggleFavorite(uid, product.id),
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
                              final uid =
                                  FirebaseAuth.instance.currentUser!.uid;
                              await CartRepository().add(
                                uid,
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
