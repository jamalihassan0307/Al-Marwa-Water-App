import 'package:hive/hive.dart';
part 'hive_create_bill_model.g.dart';

@HiveType(typeId: 5)
class HiveCreateBillModel extends HiveObject {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final int customerId;

  @HiveField(2)
  final int productId;

  @HiveField(3)
  final String trn;

  @HiveField(4)
  final String vat;

  @HiveField(5)
  final String quantity;

  @HiveField(6)
  final String rate;

  @HiveField(7)
  final String amount;

  @HiveField(8)
  final String saleUserId;

  HiveCreateBillModel({
    required this.date,
    required this.customerId,
    required this.productId,
    required this.trn,
    required this.vat,
    required this.quantity,
    required this.rate,
    required this.amount,
    required this.saleUserId,
  });

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "customer_id": customerId,
      "product_id": productId,
      "trn": trn,
      "vat": vat,
      "quantity": quantity,
      "rate": rate,
      "amount": amount,
      "sale_user_id": saleUserId,
    };
  }
}
