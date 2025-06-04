import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/presentation/product_create/model/product_model.dart';
import 'package:pico_pos/presentation/wrapper/model/cart_item_model.dart';

class CartNotifier extends ChangeNotifier {
  final Map<int, CartItemModel> _items = {};

  List<CartItemModel> get items => _items.values.toList();

  void addToCart(ProductModel product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItemModel(product: product);
    }
    notifyListeners();
  }

  void increaseQuantity(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity += 1;
      notifyListeners();
    }
  }

  void decreaseQuantity(int productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity -= 1;
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void removeFromCart(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice => _items.values
      .map((item) => item.product.price * item.quantity)
      .fold(0.0, (a, b) => a + b);
}

final cartNotifierProvider = ChangeNotifierProvider<CartNotifier>(
  (ref) => CartNotifier(),
);
