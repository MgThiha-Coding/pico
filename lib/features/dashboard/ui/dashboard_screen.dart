import 'package:flutter/material.dart';
import 'package:pico_pos/core/widgets/responsive_widget.dart';
import 'package:pico_pos/features/dashboard/ui/mobile/mobile_dashboard_screen.dart';
import 'package:pico_pos/features/dashboard/ui/tablet/tablet_dashboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: MobileDashboardScreen(),
      tablet: TabletDashboardScreen(),
    );
  }
}
