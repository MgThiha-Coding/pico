import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileAuthLoginScreen extends ConsumerStatefulWidget {
  const MobileAuthLoginScreen({super.key});

  @override
  ConsumerState<MobileAuthLoginScreen> createState() =>
      _MobileAuthLoginScreenState();
}

class _MobileAuthLoginScreenState extends ConsumerState<MobileAuthLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Mobile Auth')));
  }
}
