import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pico_pos/common/widgets/app_title.dart';
import 'package:pico_pos/common/widgets/bar_code_scanner_screen.dart';
import 'package:pico_pos/features/product_create/controller/product_notifier.dart';
import 'package:pico_pos/features/product_create/model/product_model.dart';

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
  List<String> categories = ['Add Category', 'Category 1'];
  bool isPicking = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        (_categoryInputController.text.isNotEmpty ||
            selectedCategory != null) &&
        _priceController.text.isNotEmpty &&
        _costController.text.isNotEmpty) {
      final name = _nameController.text;
      final category = selectedCategory ?? _categoryInputController.text;
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

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productNotifierProvider);
    final Set<String> categorySet = {
      ...productState.products.map((e) => e.product.category),
      if (selectedCategory != null) selectedCategory!,
    };
    final List<String> availableCategories = categorySet.toList();

    if (!availableCategories.contains(selectedCategory)) {
      selectedCategory =
          availableCategories.isNotEmpty ? availableCategories.first : null;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: AppTitle(title: "New Sale"),
        actions: [
          TextButton(
            onPressed: (){
              if ( _formKey.currentState!.validate()){
                save();
              }
            },
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: Colors.white),
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
                  validator: (value){
                    if ( value == null || value.trim().isEmpty){
                      return "Name is required";
                    }
                    return null;
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
                    suffixIcon: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Color(0xFF2A2D3E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              title: Text(
                                'Add Category',
                                style: TextStyle(color: Colors.white),
                              ),
                              content: TextField(
                                controller: _categoryInputController,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: "Add Category",
                                  hintText: "Add Category",
                                  labelStyle: TextStyle(color: Colors.white),
                                  hintStyle: TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              actionsAlignment: MainAxisAlignment.spaceEvenly,
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Save',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    final newCategory =
                                        _categoryInputController.text;
                                    if (newCategory.isNotEmpty) {
                                      setState(() {
                                        selectedCategory = newCategory;
            
                                        availableCategories.add(newCategory);
                                      });
                                      _categoryInputController.clear();
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Add',
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                ),
                                 
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.add_rounded, color: Colors.white),
                    ),
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
                      availableCategories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat,
                          child: Text(cat, style: TextStyle(color: Colors.amber)),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                   validator: (value){
                    if ( value == null || value.trim().isEmpty){
                      return "Category is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
            
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _priceController,
                        style: TextStyle(color: Colors.white),
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
                         validator: (value){
                    if ( value == null || value.trim().isEmpty){
                      return "Price is required";
                    }
                    return null;
                  },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _costController,
                        style: TextStyle(color: Colors.white),
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
                         validator: (value){
                    if ( value == null || value.trim().isEmpty){
                      return "Cost";
                    }
                    return null;
                  },
                      ),
                      
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _barcodeController,
                  style: TextStyle(color: Colors.white),
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
                    IconButton(
                      icon: const Icon(Icons.photo_library, color: Colors.white),
                      onPressed: () async {
                        await pickImage();
                        setState(() {}); 
                      },
                    ),
                  ],
                ),
            
                if (selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            selectedImage!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImage = null;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
