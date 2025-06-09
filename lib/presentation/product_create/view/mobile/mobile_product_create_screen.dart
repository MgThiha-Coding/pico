import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
  final TextEditingController _categoryInputController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  bool isImageSelected = false;
  File? selectedImage;
  String? selectedCategory;
  List<String> categories = [];
  bool isPicking = false;

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

  Future<File> _copyImage(String path) async {
    final tempDir = await getApplicationDocumentsDirectory();
    final targetPath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    return await File(path).copy(targetPath);
  }

  Future<File?> pickImageFromCamera() async {
    final picker = ImagePicker();
    final permission = await Permission.camera.request();
    if (!permission.isGranted) return null;

    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      return await compute(_copyImage, photo.path);
    }
    return null;
  }

  Future<void> save() async {
    if (_nameController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _categoryInputController.text.isNotEmpty &&
        _costController.text.isNotEmpty) {
      final name = _nameController.text;
      final category = _categoryInputController.text;
      final imagePath = selectedImage?.path;
      final price = double.tryParse(_priceController.text) ?? 0;
      final cost = _costController.text;
      final barcode = _barcodeController.text;
      final id = DateTime.now().millisecondsSinceEpoch;

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
              qty: 1,
              barcode: barcode,
            ),
          );

      Navigator.pop(context);
    }
  }

  Future<void> _showAddCategoryDialog(String newCategory) async {
    final shouldAdd = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add New Category'),
            content: Text('Do you want to add "$newCategory" to categories?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Add'),
              ),
            ],
          ),
    );

    if (shouldAdd == true && !categories.contains(newCategory)) {
      setState(() {
        categories.add(newCategory);
        selectedCategory = newCategory;
        _categoryInputController.text = newCategory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: AppTitle(title: "New Sale"),
        actions: [
          TextButton(
            onPressed: save,
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  fillColor: Colors.grey[800],
                  filled: true,
                  labelText: "Name",
                  hintText: "Name",
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(width: 1, color: Color(0xFF2697FF)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Category Text Input
              TextField(
                controller: _categoryInputController,
                decoration: InputDecoration(
                  labelText: "Category",
                  hintText: "Type category and press Enter",
                  fillColor: Colors.grey[800],
                  filled: true,

                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(width: 1, color: Color(0xFF2697FF)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  suffixIcon: Icon(Icons.inventory),
                ),
                onSubmitted: (value) {
                  final newCat = value.trim();
                  if (newCat.isNotEmpty && !categories.contains(newCat)) {
                    _showAddCategoryDialog(newCat);
                  } else if (categories.contains(newCat)) {
                    setState(() {
                      selectedCategory = newCat;
                    });
                  }
                },
              ),
              const SizedBox(height: 10),

              // Dropdown for Category
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Select Category",
                  fillColor: Colors.grey[800],
                  filled: true,

                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(width: 1, color: Color(0xFF2697FF)),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                value: selectedCategory,
                items:
                    categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                    _categoryInputController.text = value ?? "";
                  });
                },
              ),
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
                        fillColor: Colors.grey[800],
                        filled: true,

                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(width: 1, color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFF2697FF),
                          ),
                        ),
                        suffixIcon: Icon(Icons.attach_money),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
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
                        fillColor: Colors.grey[800],
                        filled: true,

                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(width: 1, color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(
                            width: 1,
                            color: Color(0xFF2697FF),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _barcodeController,
                decoration: InputDecoration(
                  labelText: "Bar Code",
                  hintText: "Bar Code",
                  fillColor: Colors.grey[800],
                  filled: true,

                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(width: 1, color: Color(0xFF2697FF)),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
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
                    icon: const Icon(
                      Icons.qr_code_scanner,
                      color: Color(0xFF2697FF),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Checkbox(
                    value: isImageSelected,
                    onChanged: (value) {
                      setState(() {
                        isImageSelected = value!;
                      });
                    },
                    activeColor: Color(0xFF2697FF),
                    checkColor: Colors.white,
                  ),
                  const Text(
                    "Add Image",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  if (isImageSelected) ...[
                    IconButton(
                      onPressed: pickImage,
                      icon: const Icon(
                        Icons.photo_library_outlined,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () async {
                        if (isPicking) return;
                        setState(() => isPicking = true);

                        final image = await pickImageFromCamera();

                        if (mounted) {
                          setState(() {
                            isPicking = false;
                            if (image != null) selectedImage = image;
                          });
                        }
                      },

                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 18),
              if (isImageSelected && selectedImage != null) ...[
                const SizedBox(height: 16),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.file(
                        selectedImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImage = null;
                            isImageSelected = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
