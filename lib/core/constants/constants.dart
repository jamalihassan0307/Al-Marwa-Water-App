import 'package:al_marwa_water_app/models/bills_model.dart';

class StaticData {
  // private constructor
  StaticData._internal();

  // single instance
  static final StaticData _instance = StaticData._internal();

  // factory constructor always returns the same instance
  factory StaticData() => _instance;

  // your shared data
  Bill? currentBill;
}
