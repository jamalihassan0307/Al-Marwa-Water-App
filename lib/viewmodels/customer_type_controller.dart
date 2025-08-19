import 'dart:developer';
import 'package:al_marwa_water_app/models/customer_type_model.dart';
import 'package:al_marwa_water_app/models/hive_customer_type_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../repositories/customers_type_repository.dart';
import '../core/utils/custom_snackbar.dart';

class CustomersTypeController with ChangeNotifier {
  final customersTypeRepository _customersTypeRepository =
      customersTypeRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CustomerTypeModel> _customersTypes = [];
  List<CustomerTypeModel> get customersTypes => _customersTypes;

  List<String> _customersTypeNames = [];
  List<String> get customersTypeNames => _customersTypeNames;

  Future<void> fetchcustomersTypes() async {
    _isLoading = true;
    notifyListeners();

    final typeBox = Hive.box<CustomerTypeHive>('all_customer_types');

    try {
      final types = await _customersTypeRepository.getcustomersTypes();
      _customersTypes = types;
      _customersTypeNames = types.map((type) => type.name ?? '').toList();

      await typeBox.clear();
      for (var model in _customersTypes) {
        typeBox.add(CustomerTypeHive.fromModel(model));
      }


      log("✅ customers types fetched and saved: ${_customersTypes.length}");
    } catch (e) {
      final offlineTypes = typeBox.values.toList();
      _customersTypes = offlineTypes.map((e) => e.toModel()).toList();
      _customersTypeNames =
          _customersTypes.map((type) => type.name ?? '').toList();

      showSnackbar(
        
          message: "Offline: Showing saved Customer Types", isError: false);
      log("❌ customersTypeController error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
