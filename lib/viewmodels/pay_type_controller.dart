import 'dart:developer';
import 'package:al_marwa_water_app/models/hive_pay_type_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/pay_type.dart';
import '../repositories/pay_type_repository.dart';
import '../core/utils/custom_snackbar.dart';

class PayTypeController with ChangeNotifier {
  final PayTypeRepository _payTypeRepository = PayTypeRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<PayType> _payTypes = [];
  List<PayType> get payTypes => _payTypes;

  List<String> _payTypeNames = [];
  List<String> get payTypeNames => _payTypeNames;
  Future<void> fetchPayTypes() async {
    _isLoading = true;
    notifyListeners();

    final payBox = Hive.box<PayTypeHive>('all_pay_types');

    try {
      // 1. Fetch from API
      final types = await _payTypeRepository.getPayTypes();
      _payTypes = types;
      _payTypeNames = types.map((type) => type.name ?? '').toList();

      // 2. Save to Hive
      await payBox.clear();
      for (var type in _payTypes) {
        payBox.add(PayTypeHive.fromPayType(type));
      }

      log("✅ Pay types fetched and saved: ${_payTypes.length}");
    } catch (e) {
      // 3. On error, load from Hive
      final localPayTypes = payBox.values.toList();
      _payTypes = localPayTypes.map((e) => e.toPayType()).toList();
      _payTypeNames = _payTypes.map((type) => type.name ?? '').toList();

      showSnackbar(message: "Offline: Showing saved Pay Types", isError: false);
      log("❌ PayTypeController error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
