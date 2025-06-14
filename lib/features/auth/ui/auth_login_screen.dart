import 'package:flutter/material.dart';
import 'package:pico_pos/core/widgets/responsive_widget.dart';
import 'package:pico_pos/features/auth/ui/mobile/mobile_auth_login_screen.dart';
import 'package:pico_pos/features/auth/ui/tablet/tablet_auth_login_screen.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: MobileAuthLoginScreen(),
      tablet: TabletAuthLoginScreen(),
    );
  }
}
