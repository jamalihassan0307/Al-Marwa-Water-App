import 'dart:developer';

import 'package:al_marwa_water_app/models/bottle_history.dart';
import 'package:al_marwa_water_app/repositories/bottle_history_repository.dart';
import 'package:flutter/material.dart';

class SaleController extends ChangeNotifier {
  final SaleRepository _saleRepository = SaleRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  BottleHistoryResponse? _saleResponse;
  BottleHistoryResponse? get saleResponse => _saleResponse;

  /// 👇 New list to hold sales entries
  List<BottleHistoryData> allSales = [];

  Future<void> getSalesByCustomerId(int customerId) async {
    _isLoading = true;

    try {
      final response = await _saleRepository.fetchSalesByCustomerId(customerId);
      _saleResponse = response;

      /// 👇 Extract and store all sales entries in a flat list
      allSales = _saleResponse?.data.expand((e) => e.entries).toList() ?? [];
    } catch (e) {
      log("SaleController Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
