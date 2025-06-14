import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/features/product_create/service/product_notifier.dart';

class DashboardProductGrid extends ConsumerStatefulWidget {
  final List<ProductEntry> filteredProducts;
  const DashboardProductGrid(this.filteredProducts, {super.key});

  @override
  ConsumerState<DashboardProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends ConsumerState<DashboardProductGrid> {
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
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Color(0xFF2A2D3E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                  actionsPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  title: Text(
                    'Delete Product',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  content: Text(
                    'Are you sure you want to delete this item?',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  actionsAlignment: MainAxisAlignment.spaceBetween,
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.greenAccent,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(productNotifierProvider.notifier)
                            .deleteProductByHiveKey(data.hiveKey);
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                );
              },
            );
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
