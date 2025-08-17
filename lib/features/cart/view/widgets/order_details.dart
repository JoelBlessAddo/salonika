// lib/features/orders/view/order_details_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:salonika/core/repo/order_repo.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId;
  const OrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final repo = OrderRepository();

    return Scaffold(
      appBar: AppBar(title: Text("Order #$orderId"), centerTitle: true),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: repo.watchOrder(uid, orderId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (!snap.hasData || snap.data == null) {
            return const Center(child: Text('Order not found'));
          }

          // Top-level map (already cast by repo, but cast again defensively)
          final order = Map<String, dynamic>.from(snap.data!);

          // Created at (num -> int)
          final createdAt = (order['createdAt'] as num?)?.toInt();

          // Shipping (map)
          final shipping = order['shipping'] is Map
              ? Map<String, dynamic>.from(order['shipping'] as Map)
              : <String, dynamic>{};

          // Items (list<map> OR map-of-maps) -> list<map>
          final rawItems = order['items'];
          final items = rawItems is List
              ? rawItems
                    .where((e) => e != null)
                    .map<Map<String, dynamic>>(
                      (e) => Map<String, dynamic>.from(e as Map),
                    )
                    .toList()
              : rawItems is Map
              ? Map<Object?, Object?>.from(rawItems).values
                    .map<Map<String, dynamic>>(
                      (e) => Map<String, dynamic>.from(e as Map),
                    )
                    .toList()
              : <Map<String, dynamic>>[];

          // Summary (map)
          final summary = order['summary'] is Map
              ? Map<String, dynamic>.from(order['summary'] as Map)
              : <String, dynamic>{};

          final status = (order['status'] as String?) ?? 'pending';
          final method = (order['paymentMethod'] as String?) ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusCard(status: status, createdAt: createdAt),
                const SizedBox(height: 12),
                _SectionTitle("Items"),
                ...items.map((it) => _ItemTile(item: it)),
                const Divider(height: 24, thickness: 1),
                _SectionTitle("Shipping"),
                _InfoRow("Name", (shipping['name'] ?? '').toString()),
                _InfoRow("Address", (shipping['address'] ?? '').toString()),
                _InfoRow("Phone", (shipping['phone'] ?? '').toString()),
                const SizedBox(height: 12),
                _SectionTitle("Payment"),
                _InfoRow("Method", method),
                const Divider(height: 24, thickness: 1),
                _SectionTitle("Summary"),
                _InfoRow(
                  "Items",
                  "${(summary['totalQty'] as num?)?.toInt() ?? 0}",
                ),
                _InfoRow(
                  "Subtotal",
                  "GHS ${(summary['subTotal'] as num? ?? 0).toStringAsFixed(2)}",
                ),
                _InfoRow(
                  "Shipping",
                  "GHS ${(summary['shippingFee'] as num? ?? 0).toStringAsFixed(2)}",
                ),
                _InfoRow(
                  "Total",
                  "GHS ${(summary['grandTotal'] as num? ?? 0).toStringAsFixed(2)}",
                  bold: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(IconlyBroken.arrow_left_2),
                    label: const Text("Back"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String status;
  final int? createdAt;
  const _StatusCard({required this.status, this.createdAt});
  @override
  Widget build(BuildContext context) {
    final when = createdAt == null
        ? '-'
        : DateTime.fromMillisecondsSinceEpoch(createdAt!).toLocal().toString();
    final color =
        {
          'pending': Colors.orange,
          'processing': Colors.blue,
          'shipped': Colors.purple,
          'delivered': Colors.green,
          'cancelled': Colors.red,
        }[status] ??
        Colors.grey;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.local_shipping_outlined, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Status: ${status[0].toUpperCase()}${status.substring(1)}",
                  style: TextStyle(color: color, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  "Placed: $when",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  const _ItemTile({required this.item});
  @override
  Widget build(BuildContext context) {
    final name = item['name'] ?? '';
    final qty = item['qty'] ?? 0;
    final price = (item['price'] as num?)?.toDouble() ?? 0;
    final subtotal = (item['subtotal'] as num?)?.toDouble() ?? price * qty;
    final image = item['imageUrl'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: image.startsWith('http')
                ? Image.network(image, width: 64, height: 64, fit: BoxFit.cover)
                : Container(
                    width: 64,
                    height: 64,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text("Qty: $qty  •  GHS ${price.toStringAsFixed(2)}"),
              ],
            ),
          ),
          Text(
            "GHS ${subtotal.toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  final bool bold;
  const _InfoRow(this.label, this.value, {this.bold = false});
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Flexible(
            child: Text(value, textAlign: TextAlign.right, style: style),
          ),
        ],
      ),
    );
  }
}
