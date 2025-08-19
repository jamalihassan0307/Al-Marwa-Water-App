import 'dart:developer';
import 'package:al_marwa_water_app/services/api_helper.dart';

import '../models/pay_type.dart';

class PayTypeRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<List<PayType>> getPayTypes() async {
    try {
      final response = await _apiHelper.get('customer-pays');

      if (response['status'] == true) {
        final List<dynamic> data = response['data'];
        log("✅ API response: ${response['data']}");
        return data.map((json) => PayType.fromJson(json)).toList();
      } else {

        throw Exception(response['message'] ?? "Failed to fetch Pay Types");
      }
    } catch (e) {
      log("❌ PayTypeRepository error: $e");
      throw Exception("PayTypeRepository error: $e");
    }
  }
}
