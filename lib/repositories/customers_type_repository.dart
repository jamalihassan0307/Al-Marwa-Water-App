import 'dart:developer';
import 'package:al_marwa_water_app/models/customer_type_model.dart';
import 'package:al_marwa_water_app/services/api_helper.dart';

class customersTypeRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<CustomerTypeModel>> getcustomersTypes() async {
    try {
      final response = await _apiHelper.get('customer-types');

      if (response['status'] == true) {
        final List<dynamic> data = response['data'];
        log("✅ API response: ${response['data']}");
        return data.map((json) => CustomerTypeModel.fromJson(json)).toList();
      } else {
        throw Exception(
            response['message'] ?? "Failed to fetch customers Types");
      }
    } catch (e) {
      log("❌ customersTypeRepository error: $e");
      throw Exception("customersTypeRepository error: $e");
    }
  }
}
