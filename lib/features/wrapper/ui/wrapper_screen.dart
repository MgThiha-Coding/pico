import 'package:flutter/material.dart';
import 'package:pico_pos/core/widgets/responsive_widget.dart';
import 'package:pico_pos/features/wrapper/ui/mobile/mobile_wrapper_main_screen.dart';
import 'package:pico_pos/features/wrapper/ui/tablet/tablet_wrapper_main_screen.dart';

class WrapperScreen extends StatefulWidget {
  const WrapperScreen({super.key});

  @override
  State<WrapperScreen> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<WrapperScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: MobileWrapperMainScreen(),
      tablet: TabletWrapperMainScreen(),
    );
  }
}
