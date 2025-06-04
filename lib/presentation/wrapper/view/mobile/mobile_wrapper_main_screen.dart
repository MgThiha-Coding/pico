import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/common/widgets/app_drawer.dart';
import 'package:pico_pos/common/widgets/app_title.dart';
import 'package:pico_pos/presentation/product_create/controller/product_notifier.dart';
import 'package:pico_pos/presentation/wrapper/controller/cart_notifier.dart';

class MobileWrapperMainScreen extends ConsumerStatefulWidget {
  const MobileWrapperMainScreen({super.key});

  @override
  ConsumerState<MobileWrapperMainScreen> createState() =>
      _MobileWrapperMainScreenState();
}

class _MobileWrapperMainScreenState
    extends ConsumerState<MobileWrapperMainScreen> {
  @override
  Widget build(BuildContext context) {
    final item = ref.watch(productNotifierProvider);
    final cartItem = ref.watch(cartNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: AppTitle(title: "Pico POS"),
      ),

      drawer: AppDrawer(),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Column(
          children: [
            const SizedBox(height: 6),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.inventory_2_outlined),
                        Text(cartItem.itemQty.toString()),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),
                Row(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Search Product',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        ref
                            .read(productNotifierProvider)
                            .updateSearchQuery(value);
                      },
                    ),
                  ],
                ),
                const SizedBox(width: 10),

                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Charges"),
                        Text(
                          '${cartItem.totalPrice.toStringAsFixed(2)} ${cartItem.cart.first.cost}',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: item.product.length,
                itemBuilder: (context, index) {
                  final data = item.product[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: ListTile(
                      onTap: () {
                        ref.read(cartNotifierProvider.notifier).addtoCart(data);
                      },

                      tileColor: Colors.grey[200],
                      // product image
                      leading:
                          data.imagePath != null
                              ? CircleAvatar(
                                backgroundImage: FileImage(
                                  File(data.imagePath!),
                                ),
                              )
                              : CircleAvatar(child: Icon(Icons.inventory)),
                      // product name
                      title: Text(
                        data.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),

                      subtitle: Row(
                        children: [
                          // product price
                          Text(
                            data.price.toStringAsFixed(2),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),

                          const SizedBox(width: 6),
                          // currency
                          Text(
                            data.cost,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
