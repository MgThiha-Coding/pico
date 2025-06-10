import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/presentation/product_create/controller/product_notifier.dart';
import 'package:pico_pos/presentation/wrapper/controller/cart_notifier.dart';

class ProductGrid extends ConsumerStatefulWidget {
  final List<ProductEntry> filteredProducts;
  const ProductGrid(this.filteredProducts, {super.key});

  @override
  ConsumerState<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends ConsumerState<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.filteredProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final data = widget.filteredProducts[index];
        return GestureDetector(
          onTap: () {
            ref.read(cartNotifierProvider.notifier).addtoCart(data.product);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child:
                      data.product.imagePath != null
                          ? Image.file(
                            File(data.product.imagePath!),
                            fit: BoxFit.cover,
                          )
                          : Container(
                            color: Color(0xFF44475A),
                            child: Center(
                              child: Icon(
                                Icons.inventory,
                                size: 40,
                                color: Colors.green,
                              ),
                            ),
                          ),
                ),

                // Floating Name & Price Bar
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${data.product.price.toStringAsFixed(2)} • ${data.product.cost}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
