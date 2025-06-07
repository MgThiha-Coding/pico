import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/common/widgets/app_drawer.dart';
import 'package:pico_pos/common/widgets/app_title.dart';
import 'package:pico_pos/presentation/product_create/controller/product_notifier.dart';
import 'package:pico_pos/presentation/wrapper/controller/cart_notifier.dart';
import 'package:pico_pos/presentation/wrapper/view/mobile/mobile_item_overview_screen.dart';

class MobileWrapperMainScreen extends ConsumerStatefulWidget {
  const MobileWrapperMainScreen({super.key});

  @override
  ConsumerState<MobileWrapperMainScreen> createState() =>
      _MobileWrapperMainScreenState();
}

class _MobileWrapperMainScreenState
    extends ConsumerState<MobileWrapperMainScreen> {
  int _currentIndex = 0; // 0 = ListView, 1 = GridView

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
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MobileItemOverviewScreen(),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          ),
        ],
      ),

      drawer: AppDrawer(),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Column(
          children: [
            const SizedBox(height: 6),

            // Cart Summary
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Charges",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        "Items: ${cartItem.itemQty}",
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[200]),
                      ),
                    ],
                  ),
                  Text(
                    '${(cartItem.totalPrice).toStringAsFixed(2)} ${cartItem.cart.isNotEmpty ? cartItem.cart.first.cost : ''}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Product List or Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _currentIndex == 0
                    ? ListView.builder(
                        itemCount: item.product.length,
                        itemBuilder: (context, index) {
                          final data = item.product[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: ListTile(
                              tileColor: Colors.grey[200],
                              onTap: () {
                                ref
                                    .read(cartNotifierProvider.notifier)
                                    .addtoCart(data);
                              },
                              leading: data.imagePath != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          FileImage(File(data.imagePath!)),
                                    )
                                  : CircleAvatar(child: Icon(Icons.inventory)),
                              title: Text(
                                data.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              subtitle: Row(
                                children: [
                                  Text(data.price.toStringAsFixed(2)),
                                  const SizedBox(width: 6),
                                  Text(data.cost),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : GridView.builder(
                        itemCount: item.product.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          final data = item.product[index];
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(cartNotifierProvider.notifier)
                                  .addtoCart(data);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: data.imagePath != null
                                        ? CircleAvatar(
                                            radius: 30,
                                            backgroundImage: FileImage(
                                                File(data.imagePath!)),
                                          )
                                        : CircleAvatar(
                                            radius: 30,
                                            child: Icon(Icons.inventory),
                                          ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    data.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${data.price.toStringAsFixed(2)} • ${data.cost}",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: "List View",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "Grid View",
          ),
        ],
      ),
    );
  }
}
