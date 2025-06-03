import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[200],
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Text(
                  'Pico POS',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Fast & Reliable",
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
          ),

          ListTile(
            onTap: () {},
            minTileHeight: 50,
            leading: Icon(Icons.point_of_sale, color: Colors.blueAccent),
            title: Text('Sales'),
          ),

          ListTile(
            onTap: () {},
            minTileHeight: 50,
            leading: Icon(Icons.inventory_2, color: Colors.blueAccent),
            title: Text('Items'),
          ),

          ListTile(
            onTap: () {},
            minTileHeight: 50,
            leading: const Icon(Icons.receipt_long, color: Colors.blueAccent),
            title: const Text('Receipt'),
          ),

          ListTile(
            onTap: () {},
            minTileHeight: 50,
            leading: const Icon(Icons.settings, color: Colors.blueAccent),
            title: const Text('Settings'),
          ),

          ListTile(
            onTap: () {},
            minTileHeight: 50,
            leading: const Icon(Icons.person, color: Colors.blueAccent),
            title: const Text('Account'),
          ),
        ],
      ),
    );
  }
}
