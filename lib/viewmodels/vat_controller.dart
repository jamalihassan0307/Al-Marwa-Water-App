import 'package:al_marwa_water_app/services/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class VatProvider with ChangeNotifier {
  int _vatPercentage = 0;
  int get vatPercentage => _vatPercentage;

  final _box = Hive.box('app_settings');

  Future<void> fetchVatPercentage() async {
    try {
      // 1. Try fetching from API
      final response = await ApiHelper().get("vat");
      // showSnackbar(message: "VAT fetched Successfully");

      if (response['status'] == true && response['vat_percentage'] != null) {
        _vatPercentage = response['vat_percentage'];

        // 2. Save to Hive for offline use
        _box.put('vat_percentage', _vatPercentage);

        debugPrint("✅ VAT fetched from API: $_vatPercentage");
      } else {
        throw Exception("Invalid VAT response");
      }
    } catch (e) {
      // 3. On error, load from Hive
      final localVat = _box.get('vat_percentage');
      if (localVat != null) {
        _vatPercentage = localVat;
        debugPrint("📦 Loaded VAT from Hive: $_vatPercentage");
      } else {
        debugPrint("❌ No VAT in Hive. Error: $e");
      }
    }

    notifyListeners();
  }
}
