import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/common/widgets/app_drawer.dart';
import 'package:pico_pos/common/widgets/app_title.dart';
import 'package:pico_pos/presentation/product_create/controller/product_notifier.dart';
import 'package:pico_pos/presentation/product_create/view/mobile/mobile_product_create_screen.dart';

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

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: AppTitle(title: "Pico POS"),
      ),
      drawer: AppDrawer(),

      body: ListView.builder(
        itemCount: item.product.length,
        itemBuilder: (context, index) {
          final data = item.product[index];
          return ListTile(
            title: Text(data.name),
            subtitle: Text(data.price.toString()),
            trailing: Text(data.cost),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MobileProductCreateScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
