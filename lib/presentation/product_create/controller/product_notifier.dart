import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pico_pos/presentation/product_create/model/product_model.dart';

class ProductNotifier extends ChangeNotifier {
  ProductNotifier() : super() {
    init();
  }

  late Box box;
  final List<ProductModel> _cart = [];

  Future<void> init() async {
    try {
      box = Hive.box('box');
    } catch (e) {
      debugPrint('Hive init error: $e');
    }
  }

  List<ProductModel> get product =>
      box.values
          .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

  List<ProductModel> get cart => UnmodifiableListView(_cart);

  Future<void> createProduct(ProductModel product) async {
    await box.add(product.toJson());
    notifyListeners();
  }

  Future<void> updateProduct(int key, ProductModel product) async {
    await box.put(key, product.toJson());
    notifyListeners();
  }

  Future<void> deleteProduct(int key) async {
    await box.delete(key);
    notifyListeners();
  }
}

final productNotifierProvider = ChangeNotifierProvider<ProductNotifier>(
  (ref) => ProductNotifier(),
);
