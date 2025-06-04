import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pico_pos/presentation/product_create/model/product_model.dart';

class CartNotifier extends ChangeNotifier {
  CartNotifier() {
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

  Future<void> addToCart(ProductModel product) async {
    int index = _cart.indexWhere((e) => e.id == product.id);
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
          qty: 1,
          barcode: product.barcode,
          imagePath: product.imagePath,
        ),
      );
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _cart.fold(0.0, (sum, item) => sum + item.qty * item.price);
  }

  List<ProductModel> get cartItems => List.unmodifiable(_cart);
}

final cartNotifierProvider = ChangeNotifierProvider<CartNotifier>(
  (ref) => CartNotifier(),
);
