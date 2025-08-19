import 'dart:developer';
import 'package:al_marwa_water_app/models/hive_products_model.dart';
import 'package:al_marwa_water_app/models/products_model.dart';
import 'package:al_marwa_water_app/repositories/products_repository.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/utils/custom_snackbar.dart';

class ProductsTypeController with ChangeNotifier {
  final ProductsRepository _ProductTypeRepository = ProductsRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ProductsModel> _ProductTypes = [];
  List<ProductsModel> get ProductTypes => _ProductTypes;

  List<String> _ProductTypeNames = [];
  List<String> get ProductTypeNames => _ProductTypeNames;
  Future<void> fetchProductTypes() async {
    _isLoading = true;
    notifyListeners();

    final productBox = Hive.box<ProductsModelHive>('all_product_types');

    try {
      // 1. Fetch from API
      final types = await _ProductTypeRepository.getProductsModel();
      _ProductTypes = types;
      _ProductTypeNames = types.map((type) => type.name ?? '').toList();

      // 2. Save to Hive
      await productBox.clear();
      for (var product in _ProductTypes) {
        productBox.add(ProductsModelHive.fromProductsModel(product));
      }
      // showSnackbar(message: "All products fetch");
      log("✅ Product types fetched from API: ${_ProductTypes.length}");
    } catch (e) {
      // 3. On error, load from Hive
      final localProducts = productBox.values.toList();
      _ProductTypes = localProducts.map((e) => e.toProductsModel()).toList();
      _ProductTypeNames = _ProductTypes.map((type) => type.name ?? '').toList();

      showSnackbar(message: "Offline: Showing saved products", isError: false);
      log("❌ ProductTypeController error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
