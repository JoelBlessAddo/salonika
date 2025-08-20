// lib/features/favorites/view/favorites_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:salonika/features/home/model/product.dart';
import 'package:salonika/features/home/view/widgets/product_details.dart'; // <-- add this
import 'package:salonika/utils/local_pro.dart';
import 'package:salonika/utils/bottom_nav.dart';
import 'package:salonika/utils/navigator.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  Stream<List<String>> _favoriteIds(String uid) {
    final ref = FirebaseDatabase.instance.ref('users/$uid/favorites');
    return ref.onValue.map((e) {
      final raw = e.snapshot.value;
      if (raw == null) return <String>[];
      final m = Map<Object?, Object?>.from(raw as Map);
      return m.entries
          .where(
            (kv) => kv.value == true || kv.value == 1 || kv.value == 'true',
          )
          .map((kv) => kv.key.toString())
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final productsStream = LocalProductRepository.instance.watchProducts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => customNavigator(context, BottomNav(pageIndex: 3)),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: StreamBuilder<List<Product>>(
        stream: productsStream,
        builder: (context, prodSnap) {
          if (!prodSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final allProducts = prodSnap.data!;

          return StreamBuilder<List<String>>(
            stream: _favoriteIds(uid),
            builder: (context, favSnap) {
              if (!favSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final ids = favSnap.data!;
              final items = allProducts
                  .where((p) => ids.contains(p.id))
                  .toList();

              if (items.isEmpty) {
                return const Center(child: Text('No favorites yet.'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: .78,
                ),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final p = items[i];
                  final isNetwork = p.imageUrl.startsWith('http');

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        customNavigator(context, ProductDetails(product: p));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: isNetwork
                                  ? Image.network(
                                      p.imageUrl,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      p.imageUrl,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'GHS ${p.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
