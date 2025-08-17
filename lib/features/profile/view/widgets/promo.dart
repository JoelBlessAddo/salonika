// lib/features/promotions/view/promotions_page.dart
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:salonika/utils/bottom_nav.dart';
import 'package:salonika/utils/navigator.dart';

class PromotionsPage extends StatelessWidget {
  const PromotionsPage({super.key});

  Stream<List<Map<String, dynamic>>> _watchPromotions() {
    final db = FirebaseDatabase.instance.ref();
    return db.child('promotions').onValue.map((e) {
      final v = e.snapshot.value;
      if (v == null) return _fallback;
      final list = <Map<String, dynamic>>[];
      if (v is List) {
        for (final it in v) {
          if (it is Map) list.add(Map<String, dynamic>.from(it));
        }
      } else if (v is Map) {
        final m = Map<Object?, Object?>.from(v);
        for (final it in m.values) {
          if (it is Map) list.add(Map<String, dynamic>.from(it));
        }
      }
      return list.isEmpty ? _fallback : list;
    });
  }

  static const _fallback = [
    {
      "title": "Free Consultation",
      "desc": "Chat with our experts about the right tractor.",
      "badge": "NEW",
    },
    {
      "title": "Spare Parts 10% Off",
      "desc": "Original SONALIKA parts — limited time.",
      "badge": "SALE",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            customNavigator(context, BottomNav(pageIndex: 3));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _watchPromotions(),
        builder: (context, snap) {
          if (!snap.hasData)
            return const Center(child: CircularProgressIndicator());
          final promos = snap.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: promos.length,
            itemBuilder: (_, i) {
              final p = promos[i];
              return Container(
                padding: const EdgeInsets.all(14),
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
                child: Row(
                  children: [
                    if ((p['badge'] ?? '').toString().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          p['badge'],
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (p['title'] ?? '').toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (p['desc'] ?? '').toString(),
                            style: TextStyle(color: Colors.grey.shade700),
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
