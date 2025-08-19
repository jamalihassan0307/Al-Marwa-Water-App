// customer_repository.dart
import 'dart:io';

import 'package:al_marwa_water_app/services/api_helper.dart';

class CustomerImageRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Map<String, dynamic>> uploadCustomerImage({
    required int customerId,
    required File imageFile,
  }) async {
    return await _apiHelper.uploadImage(
      customerId: customerId,
      imageFile: imageFile,
    );
  }
}
