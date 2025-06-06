import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pico_pos/presentation/product_create/model/product_model.dart';

class CartNotifier extends ChangeNotifier {
  CartNotifier() : super() {
    init();
  }

  late Box box;
  final List<ProductModel> _cart = [];
  int get itemKindCount => _cart.length;

  Future<void> init() async {
    try {
      box = Hive.box('box');
    } catch (e) {
      debugPrint('Hive init error: $e');
    }
  }

  List<ProductModel> get cart => UnmodifiableListView(_cart);

  void addtoCart(ProductModel product) {
    int index = _cart.indexWhere((element) => element.name == product.name);
    if (index != -1) {
      _cart[index].qty++;
    } else {
      _cart.add(
        ProductModel(
          name: product.name,
          category: product.category,
          price: product.price,
          cost: product.cost,
          id: product.id,
          qty: product.qty > 0 ? product.qty : 1,
        ),
      );
    }
    notifyListeners();
  }

  double get totalPrice {
    double total = 0.0;
    for (var item in _cart) {
      total += item.price * item.qty;
    }
    return total;
  }

  int get itemQty {
    int totalQty = 0;
    for (var i in _cart) {
      totalQty += i.qty;
    }
    return totalQty;
  }
}

final cartNotifierProvider = ChangeNotifierProvider<CartNotifier>(
  (ref) => CartNotifier(),
);
