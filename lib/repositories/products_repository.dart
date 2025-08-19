import 'dart:developer';
import 'package:al_marwa_water_app/models/products_model.dart';
import 'package:al_marwa_water_app/services/api_helper.dart';

class ProductsRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<ProductsModel>> getProductsModel() async {
    try {
      final response = await _apiHelper.get('products');

      if (response['status'] == true) {
        final List<dynamic> data = response['data'];
        log("✅ API response: ${response['data']}");
        return data.map((json) => ProductsModel.fromJson(json)).toList();
      } else {
        throw Exception(
            response['message'] ?? "Failed to fetch products Types");
      }
    } catch (e) {
      log("❌ productsTypeRepository error: $e");
      throw Exception("productsTypeRepository error: $e");
    }
  }
}
