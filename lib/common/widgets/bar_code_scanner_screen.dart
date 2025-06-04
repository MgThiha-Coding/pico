import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool isTorchOn = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void toggleTorch() {
    cameraController.toggleTorch();
    setState(() {
      isTorchOn = !isTorchOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (barcodeCapture) {
              final barcodes = barcodeCapture.barcodes;
              if (barcodes.isNotEmpty) {
                final code = barcodes.first.rawValue;
                if (code != null) {
                  Navigator.pop(context, code);
                }
              }
            },
          ),

          // Torch & camera switch buttons
          Positioned(
            top: 40,
            right: 20,
            child: Column(
              children: [
                IconButton(
                  icon: Icon(
                    isTorchOn ? Icons.flash_on : Icons.flash_off,
                    color: isTorchOn ? Colors.yellow : Colors.grey,
                  ),
                  onPressed: toggleTorch,
                ),
                const SizedBox(height: 10),
                IconButton(
                  icon: const Icon(Icons.cameraswitch),
                  color: Colors.white,
                  onPressed: () => cameraController.switchCamera(),
                ),
              ],
            ),
          ),

          // Center scan frame
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Bottom instruction
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Text(
              'Place barcode inside the box',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
