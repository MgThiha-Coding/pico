import 'dart:io'; // Added import for File

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pico_pos/common/widgets/app_drawer.dart';
import 'package:pico_pos/common/widgets/app_title.dart';

class MobileProductCreateScreen extends ConsumerStatefulWidget {
  const MobileProductCreateScreen({super.key});

  @override
  ConsumerState<MobileProductCreateScreen> createState() =>
      _MobileProductCreateScreenState();
}

class _MobileProductCreateScreenState
    extends ConsumerState<MobileProductCreateScreen> {
  final TextEditingController _barcodeController = TextEditingController();
  bool isImageSelected = false;
  File? selectedImage;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<File?> pickImageFromCamera() async {
    final picker = ImagePicker();

    // Request camera permission
    final permission = await Permission.camera.request();
    if (!permission.isGranted) {
      print('Camera permission denied');
      return null;
    }

    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      final tempDir = await getApplicationDocumentsDirectory();
      final targetPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedFile = await File(photo.path).copy(targetPath);
      print('Saved to: ${savedFile.path}');
      return savedFile;
    }

    return null;
  }

  Future<void> scanBarcode() async {
    try {
      final scannedCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // scanning line color
        'Cancel', // cancel button text
        true, // show flash icon
        ScanMode.BARCODE, // scan mode
      );

      if (scannedCode != '-1') {
        // -1 means scan canceled
        setState(() {
          // Assuming you want to put scanned barcode in a TextField, you need to store it
          // You currently have no controller for barcode TextField, so let's add that
          _barcodeController.text = scannedCode;
        });
      }
    } catch (e) {
      print('Failed to scan barcode: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: AppTitle(title: "New Sale"),
      ),
      drawer: AppDrawer(),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Name",
                hintText: "Name",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              decoration: InputDecoration(
                labelText: "Category",
                hintText: "Category",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Checkbox(
                  value: isImageSelected,
                  onChanged: (value) {
                    setState(() {
                      isImageSelected = value!;
                    });
                  },
                ),
                const Text("Image"),
              ],
            ),

            if (isImageSelected) ...[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          pickImage(); // No change here
                        },
                        icon: Icon(Icons.photo_library_outlined),
                      ),
                      const SizedBox(width: 6),
                      IconButton(
                        onPressed: () async {
                          File? imageFromCamera = await pickImageFromCamera();
                          if (imageFromCamera != null) {
                            setState(() {
                              selectedImage =
                                  imageFromCamera; // Set selectedImage after camera pick
                            });
                          }
                        },
                        icon: Icon(Icons.camera_alt),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  if (selectedImage != null) ...[
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Image.file(
                        selectedImage!,
                      ), // Display selected image file
                    ),
                  ],
                ],
              ),
            ],

            const SizedBox(height: 8),

            TextField(
              decoration: InputDecoration(
                labelText: "Price",
                hintText: "Price",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),

            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                labelText: "Cost",
                hintText: "Cost",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _barcodeController,
              decoration: InputDecoration(
                labelText: "Bar Code",
                hintText: "Bar Code",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
