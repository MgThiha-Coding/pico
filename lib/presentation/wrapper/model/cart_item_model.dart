import 'package:pico_pos/presentation/product_create/model/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  CartItemModel({required this.product, this.quantity = 1});
}
