// lib/features/cart/view/checkout.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:salonika/core/repo/cart_repo.dart';
import 'package:salonika/core/repo/order_repo.dart';
import 'package:salonika/core/repo/product_repo.dart';
import 'package:salonika/features/home/model/product.dart';
import 'package:salonika/utils/payment_method_selector.dart';
import 'package:salonika/features/cart/view/widgets/edit_address_bottomsheet.dart';
import 'package:salonika/utils/thank_you_page.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});
  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  PaymentMethod _method = PaymentMethod.creditCard; // default
  bool isChecked = true; // "Home" selected by default

  final productRepo = ProductRepository();
  final cartRepo = CartRepository();
  final orderRepo = OrderRepository();

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton.filledTonal(
              icon: const Icon(IconlyBroken.bag, size: 28),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: StreamBuilder<Map<String, Product>>(
        stream: productRepo.watchProductMap(),
        builder: (context, prodSnap) {
          if (!prodSnap.hasData)
            return const Center(child: CircularProgressIndicator());
          final products = prodSnap.data!;

          return StreamBuilder<Map<String, int>>(
            stream: cartRepo.watchCart(uid),
            builder: (context, cartSnap) {
              if (!cartSnap.hasData)
                return const Center(child: CircularProgressIndicator());
              final cart = cartSnap.data!;

              // Build summary rows
              final rows = cart.entries
                  .where((e) => products.containsKey(e.key))
                  .map((e) {
                    final p = products[e.key]!;
                    final qty = e.value;
                    final subtotal = p.price * qty;
                    return _OrderRow(
                      name: "${qty}x ${p.name}",
                      price: subtotal,
                    );
                  })
                  .toList();

              final subtotal = rows.fold<double>(0, (s, r) => s + r.price);
              const shippingFee = 0.0;
              final total = subtotal + shippingFee;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shipping card
                    const Text(
                      "Shipping Address",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _ShippingCard(
                      isChecked: isChecked,
                      onEdit: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (ctx) => EditAddressBottomSheet(
                            nameController: nameController,
                            addressController: addressController,
                            phoneController: phoneController,
                            onSave: () {
                              setState(() {});
                              Navigator.pop(ctx);
                            },
                          ),
                        );
                      },
                      name: nameController.text,
                      address: addressController.text,
                      phone: phoneController.text,
                      onCheckChanged: (v) => setState(() => isChecked = v),
                    ),
                    const SizedBox(height: 20),

                    // Payment method
                    PaymentMethodSelector(
                      initialMethod: _method,
                      onChanged: (m) => setState(() => _method = m),
                    ),
                    const SizedBox(height: 24),

                    // Order summary
                    const Text(
                      "Order Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (final r in rows) _OrderRowWidget(r),
                    const Divider(height: 20, thickness: 1),
                    _OrderRowWidget(
                      _OrderRow(name: "Subtotal", price: subtotal, bold: true),
                    ),
                    _OrderRowWidget(
                      _OrderRow(name: "Shipping", price: shippingFee),
                    ),
                    _OrderRowWidget(
                      _OrderRow(name: "Total", price: total, bold: true),
                    ),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: rows.isEmpty
                            ? null
                            : () async {
                                final methodStr =
                                    _method.name; // to store in DB
                                final orderId = await orderRepo.placeOrder(
                                  uid,
                                  cart: cart,
                                  products: products,
                                  name: nameController.text.trim(),
                                  address: addressController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  paymentMethod: methodStr,
                                );
                                if (!mounted) return;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ThankYou(orderId: orderId),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Place Order",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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

class _ShippingCard extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onCheckChanged;
  final VoidCallback onEdit;
  final String name, address, phone;

  const _ShippingCard({
    required this.isChecked,
    required this.onCheckChanged,
    required this.onEdit,
    required this.name,
    required this.address,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (v) => onCheckChanged(v ?? false),
                shape: const CircleBorder(),
                activeColor: Colors.green,
              ),
              const Text(
                "Home",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, size: 26),
                onPressed: onEdit,
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (name.isNotEmpty)
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          if (address.isNotEmpty) Text(address),
          if (phone.isNotEmpty) Text(phone),
        ],
      ),
    );
  }
}

class _OrderRow {
  final String name;
  final double price;
  final bool bold;
  _OrderRow({required this.name, required this.price, this.bold = false});
}

class _OrderRowWidget extends StatelessWidget {
  final _OrderRow row;
  const _OrderRowWidget(this.row);
  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: row.bold ? 16 : 14,
      fontWeight: row.bold ? FontWeight.w700 : FontWeight.w500,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            row.name,
            style: row.bold ? style : style.copyWith(color: Colors.grey[700]),
          ),
          Text("GHS ${row.price.toStringAsFixed(2)}", style: style),
        ],
      ),
    );
  }
}
