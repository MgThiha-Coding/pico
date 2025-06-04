class ProductModel {
  final String name;
  final String category;
  final double price;
  final String cost;
  final String? barcode;
  final String? imagePath;
  final int id;
  int qty;

  ProductModel({
    required this.name,
    required this.category,
    required this.price,
    required this.cost,
    this.barcode,
    this.imagePath,
    required this.id,
    required this.qty,
  });

  // from Json to object
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] ?? "No Item",
      category: json['category'] ?? "No Category",
      price: (json['price'] ?? 0).toDouble(),
      cost: json['cost'] ?? 0.0,
      barcode: json['barcode'],
      imagePath: json['imagePath'],
      id: json['id'] ?? 0,
      qty: json['qty'] ?? 0,
    );
  }

  // from object to Json
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "category": category,
      "price": price,
      "cost": cost,
      "barcode": barcode,
      "imagePath": imagePath,
      "id": id,
      "qty": qty,
    };
  }
}
