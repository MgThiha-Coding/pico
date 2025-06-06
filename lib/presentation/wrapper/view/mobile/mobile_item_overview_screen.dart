import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/common/widgets/app_title.dart';
import 'package:pico_pos/presentation/product_create/controller/product_notifier.dart';
import 'package:pico_pos/presentation/wrapper/controller/cart_notifier.dart';

class MobileItemOverviewScreen extends ConsumerStatefulWidget {
  const MobileItemOverviewScreen({super.key});

  @override
  ConsumerState<MobileItemOverviewScreen> createState() =>
      _MobileItemOverviewScreenState();
}

class _MobileItemOverviewScreenState
    extends ConsumerState<MobileItemOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItem = ref.watch(cartNotifierProvider);
    final item = ref.watch(productNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: AppTitle(title: "Pico POS"),
        actions: [
          // ItemKindCount
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white, width: 1.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inventory_2_outlined, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  '${cartItem.itemKindCount} items',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // Cart Item List
          Expanded(
            child: ListView.builder(
              itemCount: item.product.length,
              itemBuilder: (context, index) {
                final data = item.product[index];
                final cartProduct = cartItem.cart.firstWhere(
                  (element) => element.name == data.name,
                  //orElse: () => null,
                );
                final qty = cartProduct.qty;
                final subtotal = qty * data.price;

                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: ListTile(
                    onTap: () {
                      ref.read(cartNotifierProvider.notifier).addtoCart(data);
                    },
                    tileColor: Colors.grey[200],
                    leading:
                        data.imagePath != null
                            ? CircleAvatar(
                              backgroundImage: FileImage(File(data.imagePath!)),
                            )
                            : CircleAvatar(child: Icon(Icons.inventory)),
                    title: Text(
                      data.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    subtitle:
                        qty > 0
                            ? Text(
                              'Qty: $qty, Subtotal: \$${subtotal.toStringAsFixed(2)}',
                            )
                            : Text('Not in cart'),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 19,),
          // Total Price
          Text(
            'Total: \$${cartItem.totalPrice.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.green,
            ),
          ),
          // Print Receipt Button 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SizedBox(
              height: 50,
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () {},
                child: Text(
                  'Print Receipt',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
