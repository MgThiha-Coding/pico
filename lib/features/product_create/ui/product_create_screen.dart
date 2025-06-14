import 'package:flutter/material.dart';
import 'package:pico_pos/core/widgets/responsive_widget.dart';
import 'package:pico_pos/features/product_create/ui/mobile/mobile_product_create_screen.dart';
import 'package:pico_pos/features/product_create/ui/tablet/tablet_product_create_screen.dart';

class ProductCreateScreen extends StatefulWidget {
  const ProductCreateScreen({super.key});

  @override
  State<ProductCreateScreen> createState() => _ProductCreateScreenState();
}

class _ProductCreateScreenState extends State<ProductCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: MobileProductCreateScreen(),
      tablet: TabletProductCreateScreen(),
    );
  }
}
