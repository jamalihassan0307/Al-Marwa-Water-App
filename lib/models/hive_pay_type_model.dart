import 'package:al_marwa_water_app/models/pay_type.dart';
import 'package:hive/hive.dart';

part 'hive_pay_type_model.g.dart';

@HiveType(typeId: 3)
class PayTypeHive {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String status;

  @HiveField(2)
  final int id;

  PayTypeHive({
    required this.name,
    required this.status,
    required this.id,
  });

  factory PayTypeHive.fromPayType(PayType type) {
    return PayTypeHive(
      name: type.name ?? '',
      status: type.status ?? '',
      id: type.id ?? 0,
    );
  }

  PayType toPayType() {
    return PayType(
      name: name,
      status: status,
      id: id,
    );
  }
}
