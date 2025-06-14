import 'package:flutter/material.dart';
import 'package:pico_pos/features/dashboard/ui/mobile/mobile_dashboard_screen.dart';
import 'package:pico_pos/features/wrapper/ui/wrapper_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
     
      
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Text(
                  'Pico POS',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Fast & Reliable",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),

          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WrapperScreen()
                ),
              );
            },
            minTileHeight: 50,
            leading: Icon(Icons.point_of_sale, color: Colors.white),
            title: Text('Sales',style: TextStyle( color: Colors.white)),
          ),

          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MobileDashboardScreen(),
                ),
              );
            },
            minTileHeight: 50,
            leading: Icon(Icons.inventory_2, color: Colors.white),
            title: Text('Items',style: TextStyle( color: Colors.white)),
          ),

          ListTile(
            onTap: () {},
            minTileHeight: 50,
            leading: const Icon(Icons.receipt_long, color: Colors.white),
            title: const Text('Receipt',style: TextStyle( color: Colors.white),),
          ),

          ListTile(
            onTap: () {},
            minTileHeight: 50,
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('Settings',style: TextStyle( color: Colors.white),),
          ),

          ListTile(
            onTap: () {},
            minTileHeight: 50,
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text('Account',style: TextStyle( color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
