import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pico_pos/common/widgets/app_drawer.dart';
import 'package:pico_pos/common/widgets/app_title.dart';
import 'package:pico_pos/common/widgets/bar_code_scanner_screen.dart';
import 'package:pico_pos/presentation/product_create/controller/product_notifier.dart';
import 'package:pico_pos/presentation/product_create/model/product_model.dart';

class MobileProductCreateScreen extends ConsumerStatefulWidget {
  const MobileProductCreateScreen({super.key});

  @override
  ConsumerState<MobileProductCreateScreen> createState() =>
      _MobileProductCreateScreenState();
}

class _MobileProductCreateScreenState
    extends ConsumerState<MobileProductCreateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
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
      return null;
    }

    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      final tempDir = await getApplicationDocumentsDirectory();
      final targetPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedFile = await File(photo.path).copy(targetPath);
      return savedFile;
    }

    return null;
  }

  Future<void> save() async {
    final name = _nameController.text;
    final category = _categoryController.text;
    final imagePath = selectedImage?.path;
    final price = double.tryParse(_priceController.text) ?? 0;
    final cost = _costController.text;
    final id = 1;

    ref
        .read(productNotifierProvider.notifier)
        .createProduct(
          ProductModel(
            name: name,
            category: category,
            imagePath: imagePath,
            price: price,
            cost: cost,
            id: id,
          ),
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          save();
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: AppTitle(title: "New Sale"),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      drawer: AppDrawer(),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
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
                controller: _categoryController,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        pickImage();
                      },
                      icon: Icon(Icons.photo_library_outlined),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      onPressed: () async {
                        File? imageFromCamera = await pickImageFromCamera();
                        if (imageFromCamera != null) {
                          setState(() {
                            selectedImage = imageFromCamera;
                          });
                        }
                      },
                      icon: Icon(Icons.camera_alt),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 18),

              if (selectedImage != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: 140,
                        width: 140,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        ), // Display selected image file
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selected Image'),
                          const SizedBox(height: 10),
                          MaterialButton(
                            color: Colors.blueAccent,
                            onPressed: () {
                              setState(() {
                                selectedImage = null;
                              });
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _priceController,
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
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _costController,

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
                  ),
                ],
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _barcodeController,
                decoration: InputDecoration(
                  labelText: "Bar Code",
                  hintText: "Bar Code",
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final String? scannedCode = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BarcodeScannerScreen(),
                        ),
                      );

                      if (scannedCode != null) {
                        setState(() {
                          _barcodeController.text = scannedCode;
                        });
                      }
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                  ),

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
      ),
    );
  }
}
