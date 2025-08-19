import 'package:al_marwa_water_app/models/bottle_history.dart';
import 'package:al_marwa_water_app/services/api_helper.dart';

class SaleRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<BottleHistoryResponse> fetchSalesByCustomerId(int customerId) async {
    try {
      final response =
          await _apiHelper.getPage('bottles-by-customer', queryParams: {
        "customer_id": customerId.toString(),
      });

      return BottleHistoryResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
