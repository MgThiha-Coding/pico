import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget? desktop;
  const ResponsiveWidget({
    super.key,
    required this.mobile,
    required this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // mobile
        if (constraints.maxWidth <= 600) {
          return mobile;
        }
        // tablet
        else if (constraints.maxWidth >= 600 && constraints.maxWidth <= 1200) {
          return tablet;
        }
        // desktop is not provided
        else {
          return desktop ?? tablet;
        }
      },
    );
  }
}
