import 'dart:developer';
import 'package:al_marwa_water_app/models/get_credit_bill_model.dart';
import 'package:al_marwa_water_app/services/api_helper.dart';
import 'package:al_marwa_water_app/viewmodels/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_marwa_water_app/core/utils/custom_snackbar.dart';
import 'package:al_marwa_water_app/models/create_credit_bill_model.dart';

class CreditBillRepository {
  final ApiHelper _apiHelper = ApiHelper();

  Future<CreateCreditBillModel> createBill(
      Map<String, dynamic> billData) async {
    try {
      final response = await _apiHelper.post('credit-bills', billData);
      log("✅ Create credit Bill response: $response");

      return CreateCreditBillModel.fromJson(response);
    } catch (e) {
      log("❌ Create credit Bill repository error: $e");
      showSnackbar(
          message: "Error creating bill: ${e.toString()}", isError: true);
      rethrow;
    }
  }

  /// Fetches the list of bills for the authenticated user

//!------------------------customers Page get------------------------//
  Future<PaginatedCreditBills> getPageBills(BuildContext context,
      {int page = 1}) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final response = await _apiHelper.getPage(
      'credit-bills?sale_user_id=${authController.userId}',
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
            billList.map((json) => GetCreditBillItem.fromJson(json)).toList();

        return PaginatedCreditBills(
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
}
