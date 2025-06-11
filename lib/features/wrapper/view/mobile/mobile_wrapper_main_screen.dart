import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/common/widgets/app_drawer.dart';
import 'package:pico_pos/common/widgets/app_title.dart';
import 'package:pico_pos/common/widgets/bar_code_scanner_screen.dart';
import 'package:pico_pos/features/product_create/controller/product_notifier.dart';
import 'package:pico_pos/features/wrapper/controller/cart_notifier.dart';
import 'package:pico_pos/features/wrapper/utils/empty_widget.dart';
import 'package:pico_pos/features/wrapper/utils/product_grid.dart';
import 'package:pico_pos/features/wrapper/utils/product_list.dart';
import 'package:pico_pos/features/wrapper/view/mobile/mobile_item_overview_screen.dart';

class MobileWrapperMainScreen extends ConsumerStatefulWidget {
  const MobileWrapperMainScreen({super.key});

  @override
  ConsumerState<MobileWrapperMainScreen> createState() =>
      _MobileWrapperMainScreenState();
}

class _MobileWrapperMainScreenState
    extends ConsumerState<MobileWrapperMainScreen> {
  int _currentIndex = 0; // 0 = ListView, 1 = GridView
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _barcodeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = ref.watch(productNotifierProvider);
    final cartItem = ref.watch(cartNotifierProvider);
    _searchQuery.toLowerCase().trim();
    final filteredProducts =
        _searchQuery.isEmpty
            ? item.products
            : item.products.where((product) {
              final query = _searchQuery.toLowerCase();
              final name = product.product.name.toLowerCase();
              return name.contains(query);
            }).toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
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
                  Icon(Icons.inventory_2_outlined, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    '${cartItem.itemKindCount} ',
                    style: TextStyle(
                      color: Colors.amber,
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          children: [
            const SizedBox(height: 6),

            // Cart Summary
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2D3E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Charges",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Items: ${cartItem.itemQty}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),

                      Text(
                        '${cartItem.totalPrice.toStringAsFixed(0)} ks',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      fillColor: Colors.grey[800],
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF2697FF),
                      ),
                      hintText: 'Search...',
                      hintStyle: const TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final String? scannedCode = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const BarcodeScannerScreen(),
                            ),
                          );
                          if (scannedCode != null) {
                            ProductEntry? matchedProduct;

                            try {
                              matchedProduct = item.products.firstWhere(
                                (product) =>
                                    product.product.barcode == scannedCode,
                              );
                            } catch (e) {
                              matchedProduct = null;
                            }

                            ref
                                .read(cartNotifierProvider.notifier)
                                .addtoCart(matchedProduct!.product);
                          }
                        },
                        icon: const Icon(
                          Icons.qr_code_scanner,
                          color: Color(0xFF2697FF),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Product List or Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child:
                    filteredProducts.isEmpty
                        ? EmptyWidget()
                        : _currentIndex == 0
                        ? ProductGrid(filteredProducts)
                        : ProductList(filteredProducts),
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
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Grid"),
          BottomNavigationBarItem(icon: Icon(Icons.view_list), label: "List"),
        ],
      ),
    );
  }
}
