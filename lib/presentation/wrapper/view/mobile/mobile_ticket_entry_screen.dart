import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/common/widgets/app_title.dart';
import 'package:pico_pos/presentation/wrapper/controller/cart_notifier.dart';

class MobileTicketEntryScreen extends ConsumerStatefulWidget {
  const MobileTicketEntryScreen({super.key});

  @override
  ConsumerState<MobileTicketEntryScreen> createState() =>
      _MobileItemOverviewScreenState();
}

class _MobileItemOverviewScreenState
    extends ConsumerState<MobileTicketEntryScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItem = ref.watch(cartNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
      
        centerTitle: true,
        title: AppTitle(title: "Print Receipt"),
        actions: [
          // ItemKindCount
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
           
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.confirmation_num, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  'Ticket',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Cart Item List
            Expanded(
                child: ListView.builder(
                  itemCount: cartItem.cart.length,
                  itemBuilder: (context, index) {
                    final data = cartItem.cart[index];
                    final cartProduct = cartItem.cart.firstWhere(
                      (element) => element.name == data.name,
                      orElse: () => data,
                    );
                    final qty = cartProduct.qty;
                    final subtotal = qty * data.price;
                    
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: ListTile(
                                        
                         tileColor: Color(0xFF2A2D3E),
                      
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                               style: TextStyle( 
                                         color : Colors.white,
                                      ),
                            ),
                             qty > 0
                                ? Text('$qty × \$${subtotal.toStringAsFixed(2)}',style: TextStyle( 
                                       color: Colors.white,
                                    ),)
                                : Text('Not in cart'),
                          ],
                        ),
                       
                                
                      ),
                    );
                  },
                ),
              ),
            
        
            const SizedBox(height: 19),
            // Total Price
            Text(
              'Total: \$${cartItem.totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.green,
              ),
            ),
            // Print Receipt Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                height: 50,
                width: double.infinity,
        
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Print Recipt',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
