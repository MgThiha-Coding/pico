import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/common/widgets/app_drawer.dart';
import 'package:pico_pos/common/widgets/app_title.dart';
import 'package:pico_pos/common/widgets/bar_code_scanner_screen.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _barcodeController.addListener(() {
      if (_barcodeController.text.isEmpty) {
        setState(() {
          _searchQuery = '';
        });
      }
    });
  }

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
            ? item.product
            : item.product.where((product) {
              final query = _searchQuery.toLowerCase();
              final name = product.name.toLowerCase();
              final barcode = product.barcode.toString().toLowerCase();
              return name.contains(query) || barcode.contains(query);
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          children: [
            const SizedBox(height: 6),

            // Cart Summary
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
              color: Colors.blueGrey,
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
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Items: ${cartItem.itemQty}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[200]),
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

            const SizedBox(height: 6),

            // Search Field
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: TextField(
                // ignore: unnecessary_null_comparison
                controller: (_searchController == null)? _searchController : _barcodeController,
                decoration: InputDecoration(
                  
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search...',

                  suffixIcon: IconButton(
                    onPressed: () async {
                      final String? scannedCode = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BarcodeScannerScreen(),
                        ),
                      );
                      if (scannedCode != null) {
                        setState(() {
                          _barcodeController.text = scannedCode;
                          _searchQuery = scannedCode;
                        });
                      }
                    },
                    icon: Icon(Icons.qr_code_scanner),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
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
            ),

            const SizedBox(height: 6),

            // Product List or Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child:
                    _currentIndex == 0
                        ? ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final data = filteredProducts[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: ListTile(
                                tileColor: Colors.grey[200],
                                onTap: () {
                                  ref
                                      .read(cartNotifierProvider.notifier)
                                      .addtoCart(data);
                                },
                                leading:
                                    data.imagePath != null
                                        ? CircleAvatar(
                                          backgroundImage: FileImage(
                                            File(data.imagePath!),
                                          ),
                                        )
                                        : CircleAvatar(
                                          child: Icon(Icons.inventory),
                                        ),
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
                          itemCount: filteredProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 0.85,
                              ),
                          itemBuilder: (context, index) {
                            final data = filteredProducts[index];
                            return GestureDetector(
                              onTap: () {
                                ref
                                    .read(cartNotifierProvider.notifier)
                                    .addtoCart(data);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    // Background Image
                                    Positioned.fill(
                                      child:
                                          data.imagePath != null
                                              ? Image.file(
                                                File(data.imagePath!),
                                                fit: BoxFit.cover,
                                              )
                                              : Container(
                                                color: Colors.grey[300],
                                                child: Center(
                                                  child: Icon(
                                                    Icons.inventory,
                                                    size: 40,
                                                    color: Colors.grey[700],
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
                                        color: Colors.black.withOpacity(0.6),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              data.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "${data.price.toStringAsFixed(2)} • ${data.cost}",
                                              style: const TextStyle(
                                                color: Colors.white70,
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
            icon: Icon(Icons.view_list,),
            label: "List View",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view,),
            label : "Grid View",
          ),
        ],
      ),
    );
  }
}
