import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabletAuthLoginScreen extends ConsumerStatefulWidget {
  const TabletAuthLoginScreen({super.key});

  @override
  ConsumerState<TabletAuthLoginScreen> createState() =>
      _TabletAuthLoginScreenState();
}

class _TabletAuthLoginScreenState extends ConsumerState<TabletAuthLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Tablet Auth')));
  }
}
