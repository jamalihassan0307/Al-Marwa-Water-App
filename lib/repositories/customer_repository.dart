import 'dart:convert';
import 'dart:developer';

import 'package:al_marwa_water_app/models/customers_model.dart';
import 'package:al_marwa_water_app/services/api_helper.dart';
import 'package:al_marwa_water_app/viewmodels/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CustomerRepository {
  final ApiHelper _apiHelper = ApiHelper();
  //!------------------------customers create------------------------//
  int? _customerCreateID;
  int? get customerCreateID => _customerCreateID;
  Future<CustomerModel> createCustomer(
    Map<String, dynamic> customerData,
  ) async {
    // final response = await _apiHelper.post("customers", customerData);
    // log("Response: $response");
    // return CustomerModel.fromJson(response);
    try {
      final response = await _apiHelper.post("customers", customerData);
      log("Response: $response");
      _customerCreateID = response['data']['id'];
      log("Customer Created ID: $_customerCreateID");
      return CustomerModel.fromJson(response);
    } catch (e) {
      log("Create Customer Error: $e");
      rethrow;
    }
  }

  //!------------------------customers get------------------------//
  Future<List<CustomerData>> getCustomers(BuildContext context) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final response = await _apiHelper.get(
      'customers?sale_person_id=${authController.userId}',
    );
    // final response = await _apiHelper
    //     .get('all-customers?sale_person_id=${authController.userId}');

    try {
      final customerList = response['data']['data']; // ✅ This is a List

      if (customerList is List) {
        final customers = customerList
            .map((json) => CustomerData.fromJson(json as Map<String, dynamic>))
            .toList();
        log("✅ API response: ${response['data']}");
        return customers;
      } else {
        throw Exception("Expected a list but got: ${customerList.runtimeType}");
      }
    } catch (e) {
      log('❌ Error parsing customer list: $e');
      throw Exception("Failed to load customers: $e");
    }
  }

  //!------------------------customers Page get------------------------//
  Future<PaginatedCustomers> getPageCustomers(
    BuildContext context, {
    int page = 1,
    String search = '',
  }) async {
    final authController = Provider.of<AuthController>(context, listen: false);

    final queryParams = {
      'sale_person_id': authController.userId.toString(),
      'page': page.toString(),
    };

    if (search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await _apiHelper.getPage(
      'customers',
      queryParams: queryParams,
    );

    try {
      final data = response['data'];
      final customerList = data['data'];

      if (customerList is List) {
        final customers =
            customerList.map((json) => CustomerData.fromJson(json)).toList();

        return PaginatedCustomers(
          customers: customers,
          currentPage: data['current_page'],
          lastPage: data['last_page'],
          nextPageUrl: data['next_page_url'],
        );
      } else {
        throw Exception("Data is not a valid list");
      }
    } catch (e) {
      print('Error parsing customer list: $e');
      throw Exception("Failed to load customers: $e");
    }
  }

  //!------------------------customers put update------------------------//
  Future<Map<String, dynamic>> updateCustomer({
    required int customerId,
    required Map<String, dynamic> body,
    required String token,
  }) async {
    try {
      print("error 2");
      final http.Response response = await ApiHelper.putUpdate(
        endpoint: "customers/$customerId",
        body: body,
        token: token,
      );
      print("error 6");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded['status'] == true) {
        print("error 3");

        return {
          'success': true,
          'message': decoded['message'] ?? 'customer updated successfully.',
          'data': decoded['data'],
        };
      } else {
        print("error 4");

        return {
          'success': false,
          'message': decoded['message'] ??
              decoded['errors']?.toString() ??
              'Failed to update bill. Please try again.',
        };
      }
    } catch (e) {
      print("error 5");

      print(e);
      return {'success': false, 'message': 'Unexpected error: ${e.toString()}'};
    }
  }
}
