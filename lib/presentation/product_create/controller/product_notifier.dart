import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pico_pos/presentation/product_create/model/product_model.dart';

class ProductEntry {
  final int hiveKey;
  final ProductModel product;

  ProductEntry({
    required this.hiveKey,
    required this.product,
  });
}

class ProductNotifier extends ChangeNotifier {
  ProductNotifier() {
    init();
  }

  late Box box;

  Future<void> init() async {
    try {
      box = Hive.box('box');
    } catch (e) {
      debugPrint('Hive init error: $e');
    }
    notifyListeners();
  }

  // Build list of ProductEntry (Hive key + product model)
  List<ProductEntry> get products {
    return box.keys.map((key) {
      final productMap = Map<String, dynamic>.from(box.get(key));
      final product = ProductModel.fromJson(productMap);
      return ProductEntry(hiveKey: key as int, product: product);
    }).toList();
  }

  // You can keep cart list as is
  final List<ProductModel> _cart = [];
  List<ProductModel> get cart => UnmodifiableListView(_cart);

  Future<void> createProduct(ProductModel product) async {
    await box.add(product.toJson());
    notifyListeners();
  }

  Future<void> updateProduct(int hiveKey, ProductModel product) async {
    await box.put(hiveKey, product.toJson());
    notifyListeners();
  }

  // Delete by Hive key directly
  Future<void> deleteProductByHiveKey(int hiveKey) async {
    await box.delete(hiveKey);
    notifyListeners();
  }

  // Optional: find Hive key by product ID if needed
  int? findHiveKeyByProductId(int productId) {
    for (var key in box.keys) {
      final productMap = Map<String, dynamic>.from(box.get(key));
      if (productMap['id'] == productId) {
        return key as int;
      }
    }
    return null;
  }
}

final productNotifierProvider = ChangeNotifierProvider<ProductNotifier>(
  (ref) => ProductNotifier(),
);
