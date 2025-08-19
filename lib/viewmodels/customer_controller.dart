import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:al_marwa_water_app/core/utils/custom_snackbar.dart';
import 'package:al_marwa_water_app/models/customers_model.dart';
import 'package:al_marwa_water_app/models/hive_create_customer_model.dart';
import 'package:al_marwa_water_app/models/hive_customer_model.dart';
import 'package:al_marwa_water_app/repositories/customer_repository.dart';
import 'package:al_marwa_water_app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:loader_overlay/loader_overlay.dart';

class CustomerController extends ChangeNotifier {
  final CustomerRepository _repository = CustomerRepository();
  int? _customerCreateID;
  int? get customerCreateID => _customerCreateID;
  bool isLoading = false;
  CustomerModel? createdCustomer;
  //! --------crete new customers------------------
  Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> createCustomer(
    Map<String, dynamic> customerData,
    BuildContext context,
  ) async {
    context.loaderOverlay.show();
    isLoading = true;
    notifyListeners();

    try {
      final hasNet = await hasInternet();
      if (hasNet) {
        createdCustomer = await _repository.createCustomer(customerData);
        _customerCreateID = _repository.customerCreateID;
        showSnackbar(message: "Customer created successfully");
      } else {
        final box = Hive.box<HiveCreateCustomerModel>(
          'pending_create_customers',
        );

        final customer = HiveCreateCustomerModel(
          date: customerData["date"],
          customerType: customerData["customer_type"],
          buildingName: customerData["building_name"],
          blockNo: customerData["block_no"],
          roomNo: customerData["room_no"],
          phone1: customerData["phone1"],
          phone2: customerData["phone2"],
          deliveryDays: customerData["delivery_days"],
          customerPayId: customerData["customer_pay_id"],
          bottleGiven: customerData["bottle_given"],
          price: customerData["price"],
          paidDeposit: customerData["paid_deposit"],
          amount: customerData["amount"],
          personName: customerData["person_name"],
          phone3: customerData["phone3"],
          phone4: customerData["phone4"],
          email: customerData["email"],
          tradeName: customerData["trade_name"],
          trnNumber: customerData["trn_number"],
          authPersonName: customerData["auth_person_name"],
          salePersonId: customerData["sale_person_id"],
        );

        await box.add(customer);
        showSnackbar(message: "🕓 Offline: Customer saved locally");
      }
    } catch (e) {
      debugPrint("Create Customer Error: $e");

      String errorMessage = 'Failed to create customer';

      if (e.toString().contains('422')) {
        final jsonStart = e.toString().indexOf('{');
        if (jsonStart != -1) {
          final jsonStr = e.toString().substring(jsonStart);
          try {
            final errorJson = jsonDecode(jsonStr);
            if (errorJson['errors'] != null && errorJson['errors'] is Map) {
              final errors = errorJson['errors'] as Map<String, dynamic>;
              final messages =
                  errors.values.map((value) => value[0].toString()).toList();
              errorMessage = messages.join('\n');
            }
          } catch (_) {
            errorMessage = 'Validation error occurred.';
          }
        }
      } else if (e.toString().contains("Network Error")) {
        errorMessage = "Network Error. Please try again.";
      } else if (e.toString().contains("Server Error")) {
        errorMessage = "Server Error. Please try again later.";
      }

      showSnackbar(message: errorMessage, isError: true);
    } finally {
      isLoading = false;
      notifyListeners();
      context.loaderOverlay.hide();
    }
  }

  bool _hasSynced = false;

  Future<void> syncPendingCustomers(BuildContext context) async {
    if (_hasSynced) return;
    _hasSynced = true;

    if (await hasInternet()) {
      final box = Hive.box<HiveCreateCustomerModel>('pending_create_customers');
      if (box.isNotEmpty) {
        final customers = box.values.toList();
        log("🔄 Syncing ${customers.length} pending customers...");
        for (int i = 0; i < customers.length; i++) {
          final customer = customers[i];
          try {
            log("🔄 Syncing customer ${i + 1}/${customers.length}");
            await _repository.createCustomer(customer.toJson());
          } catch (e) {
            log("❌ Failed to sync customer: $e");
          }
        }
        await box.clear();
        log("✅ Synced and cleared all pending customers");
        showSnackbar(message: "✅ Synced pending customers");
      }
    }
  }

  //! --------Get All customers------------------

  List<CustomerData> _customers = [];
  List<CustomerData> get customers => _customers;

  List<CustomerData> _customersHive = [];
  List<CustomerData> get customersHive => _customersHive;

  Future<void> fetchCustomers(BuildContext context) async {
    context.loaderOverlay.show();
    notifyListeners();
    final customerBox = Hive.box<CustomerDataHive>('all_offline_customers');
    try {
      // 1. Fetch from API
      final apiCustomers = await _repository.getCustomers(context);
      log("Fetched from API: $apiCustomers");
      // 2. Save to Hive
      await customerBox.clear();
      for (var customer in apiCustomers) {
        customerBox.add(CustomerDataHive.fromCustomerData(customer));
      }
      // 3. Load from Hive → Convert to original model
      _customersHive = customerBox.values.toList().map((hiveModel) {
        return hiveModel.toCustomerData();
      }).toList();
      if (_customersHive.isEmpty) {
        // showSnackbar(message: "No customers found", isError: true);
      } else {
        // showSnackbar(message: "Customers fetched successfully");
      }
      _customers = _customersHive;
    } catch (e) {
      // 4. On failure, load only from Hive
      _customersHive = customerBox.values.toList().map((hiveModel) {
        return hiveModel.toCustomerData();
      }).toList();
      _customers = _customersHive;
      if (_customers.isEmpty) {
        // showSnackbar(message: "No customers found", isError: true);
      } else {
        showSnackbar(
          message: "Offline: Showing saved customers",
          isError: false,
        );
      }
      debugPrint("Error fetching from API: $e");
    }
    context.loaderOverlay.hide();
    notifyListeners();
  }

  //! --------Get page customers------------------
  List<CustomerData> _customersPagei = [];
  List<CustomerData> get customersPagei => _customersPagei;

  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoading = false;

  // Add these getters so your UI can access currentPage and lastPage
  int get currentPage => _currentPage;
  int get lastPage => _lastPage;

  Future<void> fetchCustomersPage(
    BuildContext context, {
    bool loadMore = false,
    int page = 1,
    String search = '',
  }) async {
    if (_isLoading) return; // prevent multiple calls

    if (!loadMore) {
      _currentPage = page; // update to requested page
      _customersPagei = [];
    } else {
      if (_currentPage >= _lastPage) return; // no more pages
      _currentPage++;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final paginatedData = await _repository.getPageCustomers(
        context,
        page: _currentPage,
        search: search,
      );

      if (!loadMore) {
        _customersPagei = paginatedData.customers;
      } else {
        _customersPagei.addAll(paginatedData.customers);
      }

      _lastPage = paginatedData.lastPage;

      if (_customersPagei.isEmpty) {
        // showSnackbar(message: "No customers found", isError: true);
      } else if (!loadMore) {
        // showSnackbar(message: "Customers fetched successfully");
      }
    } catch (e) {
      if (!await hasInternet()) {
        _isLoading = false;
        notifyListeners();

        await showInternetDialog(context, () {
          fetchCustomersPage(
            context,
            loadMore: loadMore,
            page: page,
          ); // 🔁 Retry
        });

        return; // ⛔ Exit early if no internet
      } else {
        showSnackbar(message: "Failed to fetch customers", isError: true);
        debugPrint("Error fetching customers: $e");
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  //!-----------------------customer update controller--------------------
  String? successMessage;
  String? errorMessage;

  Future<void> updateCustomer({
    required int customerId,
    required Map<String, dynamic> updatedData,
    required String token,
    required BuildContext context,
  }) async {
    _isLoading = true;
    successMessage = null;
    errorMessage = null;
    notifyListeners();

    try {
      print("Updating customer with ID: $customerId");
      final result = await _repository.updateCustomer(
        customerId: customerId,
        body: updatedData,
        token: token,
      );
      errorMessage = 'Something went wronghhhh here';

      if (result['success']) {
        errorMessage = 'Something went wronghhhh 1';

        successMessage = result['message'];
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, AppRoutes.customersScreen);

        log('✅ customer updated: ${result['data']}');
      } else {
        errorMessage = result['message'];
      }

      print("Update result here: $result");
    } catch (e) {
      errorMessage = 'Something went wronghhhh: $e';
      log('❌ Error updating customer: $e');
      showSnackbar(message: errorMessage!, isError: true);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> showInternetDialog(
    BuildContext context,
    VoidCallback onRetry,
  ) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("No Internet Connection"),
        content: const Text("Please check your internet and try again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRetry();
            },
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }
}
