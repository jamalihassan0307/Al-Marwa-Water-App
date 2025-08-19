import 'package:al_marwa_water_app/models/customers_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'hive_customer_model.g.dart';

@HiveType(typeId: 1)
class CustomerDataHive {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? phone;

  @HiveField(2)
  final int? id;

  @HiveField(3)
  final String? trn;

  @HiveField(4)
  final String? customerCode;

  @HiveField(5)
  final String? buildingName;

  @HiveField(6)
  final String? blockNo;

  @HiveField(7)
  final String? roomNo;
  @HiveField(8)
  final String? price;
  @HiveField(9)
  final String? tradeName;
  @HiveField(10)
  final String? authPersonName;

  CustomerDataHive({
    this.name,
    this.phone,
    this.id,
    this.trn,
    this.customerCode,
    this.buildingName,
    this.blockNo,
    this.price,
    this.roomNo,
    this.tradeName,
    this.authPersonName,
  });

  factory CustomerDataHive.fromCustomerData(CustomerData customer) {
    return CustomerDataHive(
      customerCode: customer.customerCode,
      price: customer.price,
      name: customer.personName,
      phone: customer.phone1,
      id: customer.id,
      trn: customer.trnNumber,
      roomNo: customer.roomNo,
      blockNo: customer.blockNo,
      buildingName: customer.buildingName,
      tradeName: customer.tradeName,
      authPersonName: customer.authPersonName,
    );
  }

  CustomerData toCustomerData() {
    return CustomerData(
      date: '',
      customerType: '',
      buildingName: buildingName ?? '',
      blockNo: blockNo ?? '',
      roomNo: roomNo ?? '',
      phone1: phone ?? '',
      phone2: '',
      deliveryDays: '',
      customerPayId: '',
      bottleGiven: '',
      price: price ?? '',
      paidDeposit: '',
      amount: '',
      personName: name ?? '',
      phone3: '',
      phone4: '',
      email: '',
      tradeName: tradeName ?? '',
      trnNumber: trn ?? '',
      authPersonName: authPersonName ?? '',
      salePersonId: 0,
      createdAt: '',
      updatedAt: '',
      id: id ?? 0,
      customerCode: customerCode ?? '',
    );
  }
}
