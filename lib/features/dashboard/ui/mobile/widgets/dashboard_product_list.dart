import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/features/product_create/service/product_notifier.dart';

class DashboardProductList extends ConsumerStatefulWidget {
  final List<ProductEntry> filteredProducts;
  const DashboardProductList(this.filteredProducts, {super.key});

  @override
  ConsumerState<DashboardProductList> createState() => _ProductListState();
}

class _ProductListState extends ConsumerState<DashboardProductList> {
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

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Color(0xFF2697FF)),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Color(0xFF2A2D3E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            titlePadding: const EdgeInsets.fromLTRB(
                              24,
                              20,
                              24,
                              0,
                            ),
                            contentPadding: const EdgeInsets.fromLTRB(
                              24,
                              12,
                              24,
                              0,
                            ),
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
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
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

                    icon: const Icon(Icons.delete, color: Color(0xFF2697FF)),
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
