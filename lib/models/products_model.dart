class ProductsModel {
  String? name;
  String? description;
  String? price;
  int? id;

  ProductsModel({this.name, this.id, this.description, this.price});

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
    );
  }
}
