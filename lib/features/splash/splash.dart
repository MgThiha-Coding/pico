import 'package:flutter/material.dart';
import 'package:pico_pos/features/wrapper/view/mobile/mobile_wrapper_main_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MobileWrapperMainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/images/pico.png'),
            ),
          ),
          const SizedBox(height: 20), // spacing
          SizedBox(
            width: 100, // same width as the icon container
            child: LinearProgressIndicator(
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
