import 'dart:developer';

import 'package:al_marwa_water_app/core/constants/app_images.dart';
import 'package:al_marwa_water_app/core/utils/custom_snackbar.dart';
import 'package:al_marwa_water_app/models/bills_model.dart';
import 'package:al_marwa_water_app/routes/app_routes.dart';
import 'package:al_marwa_water_app/widgets/custom_elevated_button.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  Future<void> printReceipt({
    required String receiptNo,
    required String date,
    required String customerTRN,
    required String customerName,
    required String product,
    required String tax,
    required String vat,
    required String totalAmount,
  }) async {
    try {
      List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
      if (devices.isEmpty) {
        print("No paired devices.");
        showSnackbar(
          message: "No paired devices found.",
          isError: true,
        );
        return;
      }

      BluetoothDevice printer = devices.first;
      await bluetooth.connect(printer);

      bluetooth.printNewLine();

      // Header
      bluetooth.printCustom("Al Marwa Water", 4, 1);
      bluetooth.printCustom("TRN: $customerTRN", 1, 1);
      bluetooth.printCustom("Phone: +971-12-1234567", 1, 1);
      bluetooth.printNewLine();
      bluetooth.printCustom("--------------------------------", 1, 1);
      bluetooth.printNewLine();

      // Receipt Info
      bluetooth.printCustom("Invoice #: $receiptNo", 1, 0);

      bluetooth.printCustom("Date     : $date", 1, 0);

      // Customer Info
      bluetooth.printCustom("Name        : $customerName", 1, 0);

      bluetooth.printCustom("Customer TRN: $customerTRN", 1, 0);
      bluetooth.printNewLine();

      bluetooth.printCustom("Total: $totalAmount", 2, 1);
      bluetooth.printNewLine();

      // Footer
      bluetooth.printCustom("--------------------------------", 1, 1);
      bluetooth.printNewLine();

      bluetooth.printCustom("Thank you for your purchase!", 1, 1);
      bluetooth.printCustom("AL-MARWA", 2, 1);
      bluetooth.printCustom("Downtown Dubai, UAE", 1, 1);

      bluetooth.printNewLine();
      bluetooth.paperCut();
      bluetooth.disconnect();
    } catch (e) {
      log('Print Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments == null || arguments is! Bill) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.homeScreen, (route) => false);
              },
              icon: Icon(Icons.home, color: Colors.white),
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
          ),
          title: Text(
            'Invoice Preview',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: colorScheme.primary,
        ),
        body: const Center(child: Text('No invoice data provided')),
      );
    }
    final Bill bill = arguments;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.homeScreen, (route) => false);
            },
            icon: Icon(Icons.home, color: Colors.white),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: colorScheme.onPrimary),
        ),
        title: Text(
          'Invoice Preview',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(AppImages.appLogo, height: 80),
                    Text(
                      bill.date,
                      style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _infoRow('SI NO.', bill.siNumber, textTheme),
                _infoRow('CUSTOMER NAME.', bill.customer, textTheme),
                _infoRow('SALES CODE', bill.salesCode, textTheme),
                _infoRow('PRODUCT', bill.product, textTheme),
                _infoRow('QUANTITY', bill.quantity.toString(), textTheme),
                _infoRow(
                  'RATE',
                  'AED ${bill.rate.toStringAsFixed(2)}',
                  textTheme,
                ),
                if (bill.isVAT)
                  _infoRow(
                    'VAT',
                    bill.isCreditBill ? '${bill.vatValue}%' : '0',
                    textTheme,
                  ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'GRAND TOTAL: AED ${bill.total.toStringAsFixed(2)}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Thank you for your purchase',
                  style: textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: colorScheme.onSurface.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _infoRow('TRN', bill.trn, textTheme),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'AL-MARWA',
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Downtown Dubai, Dubai UAE',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.homeScreen,
                          );
                        },
                        text: 'Cancel',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () async {
                          await printReceipt(
                            customerName: bill.customer,
                            customerTRN: bill.trn,
                            receiptNo: bill.siNumber,
                            date: bill.date,
                            totalAmount: bill.total.toStringAsFixed(2),
                            product: bill.product,
                            tax: bill.vatValue,
                            vat: bill.vatValue,
                          );
                        },
                        text: 'Print',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.editBillScreen,
                      arguments: bill,
                    );
                  },
                  text: 'Edit Bill',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
