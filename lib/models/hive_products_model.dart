import 'package:al_marwa_water_app/models/products_model.dart';
import 'package:hive/hive.dart';

part 'hive_products_model.g.dart';

@HiveType(typeId: 2)
class ProductsModelHive {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String price;

  @HiveField(3)
  final int id;

  ProductsModelHive({
    required this.name,
    required this.description,
    required this.price,
    required this.id,
  });

  factory ProductsModelHive.fromProductsModel(ProductsModel model) {
    return ProductsModelHive(
      name: model.name ?? '',
      description: model.description ?? '',
      price: model.price ?? '',
      id: model.id ?? 0,
    );
  }

  ProductsModel toProductsModel() {
    return ProductsModel(
      name: name,
      description: description,
      price: price,
      id: id,
    );
  }
}
