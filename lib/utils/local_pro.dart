// lib/core/repo/local_product_repo.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:salonika/features/home/model/product.dart';

class LocalProductRepository {
  LocalProductRepository._();
  static final instance = LocalProductRepository._();

  final _controller = StreamController<List<Product>>.broadcast();
  List<Product> _cache = [];

  Future<void> _load() async {
    final raw = await rootBundle.loadString('assets/products.json');
    final decoded = jsonDecode(raw);

    // Your new JSON is a top-level { "prod_0001": {...}, ... }
    final Map<String, dynamic> map = Map<String, dynamic>.from(decoded as Map);

    _cache = map.values
        .map((e) => Product.fromJson(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    _controller.add(_cache);
  }

  Stream<List<Product>> watchProducts() {
    if (_cache.isEmpty) {
      _load(); // fire-and-forget (first load)
    } else {
      scheduleMicrotask(() => _controller.add(_cache));
    }
    return _controller.stream;
  }

  Stream<List<Product>> search(String q) async* {
    final lower = q.trim().toLowerCase();
    if (_cache.isEmpty) await _load();
    yield _cache.where((p) {
      final inSpecs = p.specs.entries
          .map((e) => '${e.key} ${e.value}'.toLowerCase())
          .join(' ')
          .contains(lower);
      return p.name.toLowerCase().contains(lower) ||
          p.description.toLowerCase().contains(lower) ||
          inSpecs;
    }).toList();
  }

  void dispose() => _controller.close();
}
