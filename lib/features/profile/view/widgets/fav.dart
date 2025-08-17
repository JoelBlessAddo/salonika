// lib/features/favorites/view/favorites_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:salonika/utils/bottom_nav.dart';
import 'package:salonika/utils/navigator.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  Stream<List<Map<String, dynamic>>> _watchFavorites() async* {
    final db = FirebaseDatabase.instance.ref();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final favStream = db.child('users/$uid/favorites').onValue.map((e) {
      final raw = e.snapshot.value;
      if (raw == null) return <String>[];
      final m = Map<Object?, Object?>.from(raw as Map);
      // keep truthy values
      return m.entries
          .where(
            (kv) => kv.value == true || kv.value == 1 || kv.value == 'true',
          )
          .map((kv) => kv.key.toString())
          .toList();
    });

    await for (final ids in favStream) {
      final prodsSnap = await db.child('products').get();
      final list = <Map<String, dynamic>>[];
      if (prodsSnap.exists) {
        final all = Map<Object?, Object?>.from(prodsSnap.value as Map);
        for (final id in ids) {
          final v = all[id];
          if (v is Map) {
            list.add(Map<String, dynamic>.from(v));
          }
        }
      }
      yield list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            customNavigator(context, BottomNav(pageIndex: 3));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _watchFavorites(),
        builder: (context, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());
          final items = snap.data!;
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
              final name = (p['name'] ?? '').toString();
              final price = (p['price'] as num?)?.toDouble() ?? 0;
              final image = (p['imageUrl'] ?? '').toString();
              return Container(
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
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: image.startsWith('http')
                          ? Image.network(
                              image,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/tractor.jpg',
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
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'GHS ${price.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
