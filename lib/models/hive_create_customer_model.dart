import 'package:hive/hive.dart';
part 'hive_create_customer_model.g.dart';

@HiveType(typeId: 8)
class HiveCreateCustomerModel extends HiveObject {
  @HiveField(0)
  final String date;

  @HiveField(1)
  final String customerType;

  @HiveField(2)
  final String buildingName;

  @HiveField(3)
  final String blockNo;

  @HiveField(4)
  final String roomNo;

  @HiveField(5)
  final String phone1;

  @HiveField(6)
  final String phone2;

  @HiveField(7)
  final String deliveryDays;

  @HiveField(8)
  final String customerPayId;

  @HiveField(9)
  final String bottleGiven;

  @HiveField(10)
  final String price;

  @HiveField(11)
  final String paidDeposit;

  @HiveField(12)
  final String amount;

  @HiveField(13)
  final String personName;

  @HiveField(14)
  final String phone3;

  @HiveField(15)
  final String phone4;

  @HiveField(16)
  final String email;

  @HiveField(17)
  final String tradeName;

  @HiveField(18)
  final String trnNumber;

  @HiveField(19)
  final String authPersonName;

  @HiveField(20)
  final int salePersonId;

  HiveCreateCustomerModel({
    required this.date,
    required this.customerType,
    required this.buildingName,
    required this.blockNo,
    required this.roomNo,
    required this.phone1,
    required this.phone2,
    required this.deliveryDays,
    required this.customerPayId,
    required this.bottleGiven,
    required this.price,
    required this.paidDeposit,
    required this.amount,
    required this.personName,
    required this.phone3,
    required this.phone4,
    required this.email,
    required this.tradeName,
    required this.trnNumber,
    required this.authPersonName,
    required this.salePersonId,
  });

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "customer_type": customerType,
      "building_name": buildingName,
      "block_no": blockNo,
      "room_no": roomNo,
      "phone1": phone1,
      "phone2": phone2,
      "delivery_days": deliveryDays,
      "customer_pay_id": customerPayId,
      "bottle_given": bottleGiven,
      "price": price,
      "paid_deposit": paidDeposit,
      "amount": amount,
      "person_name": personName,
      "phone3": phone3,
      "phone4": phone4,
      "email": email,
      "trade_name": tradeName,
      "trn_number": trnNumber,
      "auth_person_name": authPersonName,
      "sale_person_id": salePersonId,
    };
  }
}
