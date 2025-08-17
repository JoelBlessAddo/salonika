// ignore_for_file: deprecated_member_use
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:salonika/core/repo/product_repo.dart';
import 'package:salonika/features/home/model/product.dart';
import 'package:salonika/features/home/view/widgets/product_card.dart';
import 'package:salonika/utils/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final repo = ProductRepository();

  final _searchCtrl = TextEditingController();
  String _query = '';
  Timer? _debounce;

  static const _shopNumber = '0545755752';

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 220), () {
      setState(() => _query = value.trim().toLowerCase());
    });
  }

  Future<void> _callShop() async {
    final uri = Uri(scheme: 'tel', path: _shopNumber);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to open dialer')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Search
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _searchCtrl,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[600],
                          ),
                          hintText: "Search tractors, implements…",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                          suffixIcon: (_query.isNotEmpty)
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    _onSearchChanged('');
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Promo banner with Call action
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(205, 157, 236, 160),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      bottom: 145,
                      left: 20,
                      child: Text(
                        'Free Consultation',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 90,
                      left: 20,
                      child: Text(
                        'Get free support from our\ncustomer service',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: InkWell(
                        onTap: _callShop,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 50,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Call Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Container(
                        height: 120,
                        width: 140,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            'assets/consultation.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Featured Products",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Products + filter by _query
              StreamBuilder<List<Product>>(
                stream: repo.watchProducts(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final all = snap.data!;
                  final q = _query;
                  final products = q.isEmpty
                      ? all
                      : all.where((p) {
                          final name = (p.name).toLowerCase();
                          final desc = (p.description).toLowerCase();
                          return name.contains(q) || desc.contains(q);
                        }).toList();

                  if (products.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Text('No results found.'),
                          const SizedBox(height: 6),
                          Text(
                            '“$_query”',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.9,
                        ),
                    itemCount: products.length,
                    itemBuilder: (_, i) => ProductCard(product: products[i]),
                  );
                },
              ),

              const SizedBox(height: 80), // leave space for FAB
            ],
          ),
        ),
      ),
    );
  }
}
