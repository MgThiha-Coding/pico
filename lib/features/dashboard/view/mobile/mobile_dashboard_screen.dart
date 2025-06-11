import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/common/widgets/app_drawer.dart';
import 'package:pico_pos/common/widgets/app_title.dart';
import 'package:pico_pos/features/product_create/view/mobile/mobile_product_create_screen.dart';
import 'package:pico_pos/features/product_create/controller/product_notifier.dart';
import 'package:pico_pos/features/wrapper/utils/empty_widget.dart';

class MobileDashboardScreen extends ConsumerStatefulWidget {
  const MobileDashboardScreen({super.key});

  @override
  ConsumerState<MobileDashboardScreen> createState() =>
      _MobileDashboardScreenState();
}

class _MobileDashboardScreenState extends ConsumerState<MobileDashboardScreen> {
  int _currentIndex = 0; // 0 = ListView, 1 = GridView
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = ref.watch(productNotifierProvider);

    final query = _searchQuery.toLowerCase().trim();

    final filteredProducts =
        query.isEmpty
            ? item.products
            : item.products.where((product) {
              final name = product.product.name.toLowerCase();
              return name.contains(query);
            }).toList();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        //  backgroundColor: Colors.blueAccent,
        shape: const CircleBorder(),
        backgroundColor: Color(0xFF2697FF),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MobileProductCreateScreen(),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const AppTitle(title: "Dashboard"),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Column(
          children: [
            const SizedBox(height: 6),
            // Search Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  fillColor: Colors.grey[800],
                  filled: true,
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
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
            const SizedBox(height: 10),
            // Product List or Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child:
                    filteredProducts.isEmpty
                        ? EmptyWidget()
                        : _currentIndex == 0
                        ? ListView.builder(
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final data = filteredProducts[index];
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  width: 1,
                                  color: Color(0xFF44475A),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: ListTile(
                                  tileColor: Color(0xFF2A2D3E),

                                  leading:
                                      data.product.imagePath != null
                                          ? CircleAvatar(
                                            backgroundImage: FileImage(
                                              File(data.product.imagePath!),
                                            ),
                                          )
                                          : const CircleAvatar(
                                            child: Icon(Icons.inventory),
                                          ),
                                  title: Text(
                                    data.product.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        data.product.price.toStringAsFixed(2),
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
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Color(0xFF2697FF),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                backgroundColor: Color(
                                                  0xFF2A2D3E,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                titlePadding:
                                                    const EdgeInsets.fromLTRB(
                                                      24,
                                                      20,
                                                      24,
                                                      0,
                                                    ),
                                                contentPadding:
                                                    const EdgeInsets.fromLTRB(
                                                      24,
                                                      12,
                                                      24,
                                                      0,
                                                    ),
                                                actionsPadding:
                                                    const EdgeInsets.symmetric(
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
                                                actionsAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.greenAccent,
                                                    ),
                                                    child: const Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      ref
                                                          .read(
                                                            productNotifierProvider
                                                                .notifier,
                                                          )
                                                          .deleteProductByHiveKey(
                                                            data.hiveKey,
                                                          );
                                                      Navigator.pop(context);
                                                    },
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.redAccent,
                                                    ),
                                                    child: const Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },

                                        icon: const Icon(
                                          Icons.delete,
                                          color: Color(0xFF2697FF),
                                        ),
                                      ),
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
                              onLongPress: () {
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
                                      actionsPadding:
                                          const EdgeInsets.symmetric(
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
                                      actionsAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
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
                                                .read(
                                                  productNotifierProvider
                                                      .notifier,
                                                )
                                                .deleteProductByHiveKey(
                                                  data.hiveKey,
                                                );
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
