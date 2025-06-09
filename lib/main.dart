import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pico_pos/presentation/wrapper/view/mobile/mobile_wrapper_main_screen.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) => ThemeNotifier(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('box');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,

      // LIGHT THEME
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor:  Color(0xFF2A2D3E), // default background
        appBarTheme: const AppBarTheme(
          backgroundColor:  Color(0xFF2A2D3E),  // appbar bg color
          foregroundColor: Colors.white, // appbar text/icon color
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.black54),
          titleLarge: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blueGrey,
        ),
        drawerTheme: DrawerThemeData(backgroundColor: Color(0xFF2A2D3E)),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor:    Color(0xFF2A2D3E), 
          selectedIconTheme: const IconThemeData(color: Colors.amber),
          unselectedIconTheme: const IconThemeData(color: Colors.white),
          selectedItemColor:  Colors.amber,
          unselectedItemColor: Colors.white,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF2697FF),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      

      home: const MobileWrapperMainScreen(),
    );
  }
}
