import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pico_pos/presentation/wrapper/view/mobile/mobile_wrapper_main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize hive database
  await Hive.initFlutter();
  // open the hive database
  await Hive.openBox('box');
  // runApp
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MobileWrapperMainScreen(),
    );
  }
}
