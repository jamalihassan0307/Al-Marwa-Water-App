import 'dart:convert';
import 'dart:developer';

import 'package:al_marwa_water_app/models/create_bill_model.dart';
import 'package:al_marwa_water_app/core/utils/custom_snackbar.dart';
import 'package:al_marwa_water_app/models/get_bill_model.dart';
import 'package:al_marwa_water_app/services/api_helper.dart';
import 'package:al_marwa_water_app/viewmodels/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BillRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<CreateBillResponseModel> createBill(
    Map<String, dynamic> billData,
  ) async {
    try {
      final response = await _apiHelper.post('bills', billData);
      log("✅ Create Bill response: $response");

      return CreateBillResponseModel.fromJson(response);
    } catch (e) {
      log("❌ Create Bill repository error: $e");
      showSnackbar(
        message: "Error creating bill: ${e.toString()}",
        isError: true,
      );
      rethrow;
    }
  }

  /// Fetches the list of bills for the authenticated user

  //!------------------------bill Page get------------------------//
  Future<PaginatedBills> getPageBills(
    BuildContext context, {
    int page = 1,
  }) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final response = await _apiHelper.getPage(
      'bills?sale_user_id=${authController.userId}',
      queryParams: {
        'sale_user_id': authController.userId.toString(),
        'page': page.toString(),
      },
    );

    try {
      final data = response['data'];
      final billList = data['data'];

      if (billList is List) {
        final bills =
            billList.map((json) => GetBillItem.fromJson(json)).toList();

        return PaginatedBills(
          bills: bills,
          currentPage: data['current_page'],
          lastPage: data['last_page'],
          nextPageUrl: data['next_page_url'],
        );
      } else {
        throw Exception("Data is not a valid list");
      }
    } catch (e) {
      print('Error parsing bill list: $e');
      throw Exception("Failed to load bills: $e");
    }
  }

  //!------------------------bill and credit put repo------------------------//
  Future<Map<String, dynamic>> updateBill({
    required int billId,
    required Map<String, dynamic> body,
    required String token,
  }) async {
    try {
      final http.Response response = await ApiHelper.putUpdate(
        endpoint: "bills/$billId",
        body: body,
        token: token,
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded['status'] == true) {
        return {
          'success': true,
          'message': decoded['message'] ?? 'Bill updated successfully.',
          'data': decoded['data'],
        };
      } else {
        return {
          'success': false,
          'message': decoded['message'] ??
              decoded['errors']?.toString() ??
              'Failed to update bill. Please try again.',
        };
      }
    } catch (e) {
      print(e);
      return {'success': false, 'message': 'Unexpected error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> updateCreditBill({
    required int billId,
    required Map<String, dynamic> body,
    required String token,
  }) async {
    try {
      final http.Response response = await ApiHelper.putUpdate(
        endpoint: "credit-bills/$billId",
        body: body,
        token: token,
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded['status'] == true) {
        return {
          'success': true,
          'message': decoded['message'] ?? 'Bill updated successfully.',
          'data': decoded['data'],
        };
      } else {
        return {
          'success': false,
          'message': decoded['message'] ??
              decoded['errors']?.toString() ??
              'Failed to update bill. Please try again.',
        };
      }
    } catch (e) {
      print(e);
      return {'success': false, 'message': 'Unexpected error: ${e.toString()}'};
    }
  }
}
