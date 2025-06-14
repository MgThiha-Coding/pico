import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/features/product_create/service/product_notifier.dart';
import 'package:pico_pos/features/wrapper/service/cart_notifier.dart';

class ProductList extends ConsumerStatefulWidget {
  final List<ProductEntry> filteredProducts;
  const ProductList(this.filteredProducts, {super.key});

  @override
  ConsumerState<ProductList> createState() => _ProductListState();
}

class _ProductListState extends ConsumerState<ProductList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.filteredProducts.length,
      itemBuilder: (context, index) {
        final data = widget.filteredProducts[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(width: 1, color: Color(0xFF44475A)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: ListTile(
              tileColor: Color(0xFF35374A),
              onTap: () {
                ref.read(cartNotifierProvider.notifier).addtoCart(data.product);
              },
              leading:
                  data.product.imagePath != null
                      ? CircleAvatar(
                        backgroundImage: FileImage(
                          File(data.product.imagePath!),
                        ),
                      )
                      : CircleAvatar(child: Icon(Icons.inventory)),
              title: Text(
                data.product.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Row(
                children: [
                  Text(
                    data.product.price.toStringAsFixed(0),
                    style: TextStyle(color: Colors.green),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    data.product.cost,
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
