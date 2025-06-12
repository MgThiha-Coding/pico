import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/common/widgets/app_drawer.dart';
import 'package:pico_pos/common/widgets/app_title.dart';
import 'package:pico_pos/common/widgets/empty_widget.dart';
import 'package:pico_pos/features/dashboard/view/mobile/widgets/dashboard_product_grid.dart';
import 'package:pico_pos/features/dashboard/view/mobile/widgets/dashboard_product_list.dart';
import 'package:pico_pos/features/product_create/view/mobile/mobile_product_create_screen.dart';
import 'package:pico_pos/features/product_create/controller/product_notifier.dart';

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
        centerTitle: false,
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
                        ? DashboardProductGrid(filteredProducts)
                        : DashboardProductList(filteredProducts),
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
