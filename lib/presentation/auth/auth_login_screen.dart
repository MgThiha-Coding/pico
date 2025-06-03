import 'package:flutter/material.dart';
import 'package:pico_pos/common/responsive_widget.dart';
import 'package:pico_pos/presentation/auth/mobile/mobile_auth_login_screen.dart';
import 'package:pico_pos/presentation/auth/tablet/tablet_auth_login_screen.dart';

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
