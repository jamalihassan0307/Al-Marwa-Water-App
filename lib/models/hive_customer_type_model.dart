import 'package:al_marwa_water_app/models/customer_type_model.dart';
import 'package:hive/hive.dart';

part 'hive_customer_type_model.g.dart';

@HiveType(typeId: 4)
class CustomerTypeHive {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String status;

  @HiveField(2)
  final int id;

  CustomerTypeHive({
    required this.name,
    required this.status,
    required this.id,
  });

  factory CustomerTypeHive.fromModel(CustomerTypeModel model) {
    return CustomerTypeHive(
      name: model.name ?? '',
      status: model.status ?? '',
      id: model.id ?? 0,
    );
  }

  CustomerTypeModel toModel() {
    return CustomerTypeModel(
      name: name,
      status: status,
      id: id,
    );
  }
}
