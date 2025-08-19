import 'package:al_marwa_water_app/app.dart';
import 'package:al_marwa_water_app/models/hive_create_bill_model.dart';
import 'package:al_marwa_water_app/models/hive_create_credit_model.dart';
import 'package:al_marwa_water_app/models/hive_create_customer_model.dart';
import 'package:al_marwa_water_app/models/hive_customer_model.dart';
import 'package:al_marwa_water_app/models/hive_customer_type_model.dart';
import 'package:al_marwa_water_app/models/hive_issue_bottle_model.dart';
import 'package:al_marwa_water_app/models/hive_pay_type_model.dart';
import 'package:al_marwa_water_app/models/hive_products_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive with path
  // await Hive.deleteFromDisk();

  // Hive for Customer Data 1
  Hive.registerAdapter(CustomerDataHiveAdapter());
  if (!Hive.isBoxOpen('all_offline_customers')) {
    await Hive.openBox<CustomerDataHive>('all_offline_customers');
  }
  // Hive for Products Data 2
  Hive.registerAdapter(ProductsModelHiveAdapter());
  if (!Hive.isBoxOpen('all_product_types')) {
    await Hive.openBox<ProductsModelHive>('all_product_types');
  }
  // Hive for Pay Types 3
  Hive.registerAdapter(PayTypeHiveAdapter());
  if (!Hive.isBoxOpen('all_pay_types')) {
    await Hive.openBox<PayTypeHive>('all_pay_types');
  }

  // Hive for Customer Types 4
  Hive.registerAdapter(CustomerTypeHiveAdapter());
  if (!Hive.isBoxOpen('all_customer_types')) {
    await Hive.openBox<CustomerTypeHive>('all_customer_types');
  }

  // Hive for Pending Create Bill Orders 5
  Hive.registerAdapter(HiveCreateBillModelAdapter());
  await Hive.openBox<HiveCreateBillModel>('pending_create_bills');

  // Hive for Pending Bottle Orders 6
  Hive.registerAdapter(HiveBottleIssueAdapter());
  await Hive.openBox<HiveBottleIssue>('pending_bottle_orders');

  // Hive for Credit Bills 7
  if (!Hive.isAdapterRegistered(7)) {
    Hive.registerAdapter(HiveCreditBillModelAdapter());
  }
  await Hive.openBox<HiveCreditBillModel>('pending_create_credit_bills');

  // Hive for offline customers 8
// Hive for offline customers 8
  Hive.registerAdapter(HiveCreateCustomerModelAdapter());
  await Hive.openBox<HiveCreateCustomerModel>('pending_create_customers');

  await Hive.openBox('app_settings');

  runApp(MyApp());
}
