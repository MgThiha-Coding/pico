import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2, size: 35, color: Color(0xFF2697FF)),
          const SizedBox(height: 10),
          Text("No Products", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
