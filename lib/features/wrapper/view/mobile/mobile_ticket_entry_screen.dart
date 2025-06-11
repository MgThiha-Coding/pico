import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pico_pos/common/widgets/app_title.dart';
import 'package:pico_pos/features/wrapper/controller/cart_notifier.dart';

// Add this import:
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';

class MobileTicketEntryScreen extends ConsumerStatefulWidget {
  const MobileTicketEntryScreen({super.key});

  @override
  ConsumerState<MobileTicketEntryScreen> createState() =>
      _MobileItemOverviewScreenState();
}

class _MobileItemOverviewScreenState
    extends ConsumerState<MobileTicketEntryScreen> {
  // Add a controller for the receipt
  ReceiptController? _receiptController;

  // Build the receipt widget for printing
  Widget _buildReceipt(cartItem) {
    return Receipt(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Receipt',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          SizedBox(height: 8),
          Divider(),
          ...cartItem.cart.map<Widget>((item) {
            final subtotal = item.qty * item.price;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('${item.name} x${item.qty}')),
                  Text('\$${subtotal.toStringAsFixed(2)}'),
                ],
              ),
            );
          }).toList(),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$${cartItem.totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
      onInitialized: (ctrl) => _receiptController = ctrl,
    );
  }

  // Print function
  Future<void> _printReceipt(BuildContext context, cartItem) async {
    final device = await FlutterBluetoothPrinter.selectDevice(context);
    if (device != null && _receiptController != null) {
      await _receiptController!.print(address: device.address);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Printing...')),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Printer not selected or not ready')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItem = ref.watch(cartNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: AppTitle(title: "Print Receipt"),
        actions: [
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
            // Receipt widget (hidden, just for printing)
            Offstage(child: _buildReceipt(cartItem)),
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
                            style: TextStyle(color: Colors.white),
                          ),
                          qty > 0
                              ? Text(
                                  '$qty × \$${subtotal.toStringAsFixed(2)}',
                                  style: TextStyle(color: Colors.white),
                                )
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: () => _printReceipt(context, cartItem),
                  child: Text(
                    'Print Receipt',
                    style: TextStyle(color: Colors.grey[800]),
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
