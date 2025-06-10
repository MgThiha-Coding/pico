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
                color: Color(0xFF2A2D3E),
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
                        '${(cartItem.totalPrice).toStringAsFixed(0)} ${cartItem.cart.isNotEmpty ? cartItem.cart.first.cost : ''}',
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
                    style: TextStyle( 
                       color: Colors.white
                    ),
                    decoration: InputDecoration(
                      fillColor: Colors.grey[800],
                      filled: true,
                      prefixIcon: Icon(Icons.search,color : Color(0xFF2697FF)),
                      hintText: 'Search...',
                      hintStyle: TextStyle( 
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final String? scannedCode = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const BarcodeScannerScreen(),
                            ),
                          );

                         
                        },
                        icon: const Icon(Icons.qr_code_scanner,color : Color(0xFF2697FF)),
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

            const SizedBox(height: 6),

            // Product List or Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: filteredProducts.isEmpty? Center( 
                   child : Column( 
                     mainAxisAlignment: MainAxisAlignment.center,
                     children:[
                        Icon(Icons.inventory_2,size : 35, color : Color(0xFF2697FF)),
                        const SizedBox(height : 10),
                        Text("No Products Found",style:TextStyle( 
                           color : Colors.white,
                        )),
                     ]
                   )
                ) : 
                    _currentIndex == 0
                        ? ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final data = filteredProducts[index];
                            return Container(
                              decoration: BoxDecoration( 
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all( width: 1, color : Color(0xFF44475A))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: ListTile(
                                  tileColor: Color(0xFF35374A),
                                  onTap: () {
                                    ref
                                        .read(cartNotifierProvider.notifier)
                                        .addtoCart(data.product);
                                  },
                                  leading:
                                      data.product.imagePath != null
                                          ? CircleAvatar(
                                            backgroundImage: FileImage(
                                              File(data.product.imagePath!),
                                            ),
                                          )
                                          : CircleAvatar(
                                            child: Icon(Icons.inventory),
                                          ),
                                  title: Text(
                                    data.product.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle( 
                                       color : Colors.white,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(data.product.price.toStringAsFixed(0),style: TextStyle( 
                                         color : Colors.green,
                                      ),),
                                      const SizedBox(width: 6),
                                      Text(data.product.cost,style: TextStyle( 
                                         color: Colors.green
                                      ),),
                                    ],
                                  ),
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
                                    .addtoCart(data.product);
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
                                                color:  Color(0xFF44475A),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
            label: "List",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "Grid",
          ),
        ],
      ),
    );
  }
}
