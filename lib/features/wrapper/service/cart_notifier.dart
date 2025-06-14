import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pico_pos/model/product_model.dart';

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
          imagePath: product.imagePath,
          qty: product.qty > 0 ? product.qty : 1,
        ),
      );
    }
    notifyListeners();
  }

  void reduceQty(ProductModel product) {
    int index = _cart.indexWhere((element) => element.name == product.name);
    if (index != -1) {
      if (_cart[index].qty > 1) {
        _cart[index].qty--;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void deleteCartItem(int id) async {
    _cart.removeAt(id);
    notifyListeners();
  }

  void clearCart() async {
    _cart.clear();
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



/*
class CartNotifier extends ChangeNotifier {
  CartNotifier() {
    _loadCart();
  }

  final List<ProductModel> _cart = [];
  List<ProductModel> get cart => UnmodifiableListView(_cart);

  int get itemKindCount => _cart.length;
  int get itemQty => _cart.fold(0, (sum, item) => sum + item.qty);
  double get totalPrice => _cart.fold(0.0, (sum, item) => sum + (item.price * item.qty));

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getStringList('cart') ?? [];
    _cart.clear();
    _cart.addAll(cartJson.map((e) => ProductModel.fromJson(jsonDecode(e))));
    notifyListeners();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = _cart.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('cart', cartJson);
  }

  void addtoCart(ProductModel product) async {
    int index = _cart.indexWhere((e) => e.name == product.name);
    if (index != -1) {
      _cart[index].qty++;
    } else {
      _cart.add(ProductModel(
        name: product.name,
        category: product.category,
        price: product.price,
        cost: product.cost,
        id: product.id,
        imagePath: product.imagePath,
        qty: product.qty > 0 ? product.qty : 1,
      ));
    }
    await _saveCart();
    notifyListeners();
  }

  void reduceQty(ProductModel product) async {
    int index = _cart.indexWhere((e) => e.name == product.name);
    if (index != -1) {
      if (_cart[index].qty > 1) {
        _cart[index].qty--;
      } else {
        _cart.removeAt(index);
      }
      await _saveCart();
      notifyListeners();
    }
  }

  void deleteCartItem(int index) async {
    if (index >= 0 && index < _cart.length) {
      _cart.removeAt(index);
      await _saveCart();
      notifyListeners();
    }
  }

  void clearCart() async {
    _cart.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart');
    notifyListeners();
  }
}

final cartNotifierProvider = ChangeNotifierProvider<CartNotifier>(
  (ref) => CartNotifier(),
);
*/