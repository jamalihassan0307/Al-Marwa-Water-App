// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_create_customer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveCreateCustomerModelAdapter
    extends TypeAdapter<HiveCreateCustomerModel> {
  @override
  final int typeId = 8;

  @override
  HiveCreateCustomerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCreateCustomerModel(
      date: fields[0] as String,
      customerType: fields[1] as String,
      buildingName: fields[2] as String,
      blockNo: fields[3] as String,
      roomNo: fields[4] as String,
      phone1: fields[5] as String,
      phone2: fields[6] as String,
      deliveryDays: fields[7] as String,
      customerPayId: fields[8] as String,
      bottleGiven: fields[9] as String,
      price: fields[10] as String,
      paidDeposit: fields[11] as String,
      amount: fields[12] as String,
      personName: fields[13] as String,
      phone3: fields[14] as String,
      phone4: fields[15] as String,
      email: fields[16] as String,
      tradeName: fields[17] as String,
      trnNumber: fields[18] as String,
      authPersonName: fields[19] as String,
      salePersonId: fields[20] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCreateCustomerModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.customerType)
      ..writeByte(2)
      ..write(obj.buildingName)
      ..writeByte(3)
      ..write(obj.blockNo)
      ..writeByte(4)
      ..write(obj.roomNo)
      ..writeByte(5)
      ..write(obj.phone1)
      ..writeByte(6)
      ..write(obj.phone2)
      ..writeByte(7)
      ..write(obj.deliveryDays)
      ..writeByte(8)
      ..write(obj.customerPayId)
      ..writeByte(9)
      ..write(obj.bottleGiven)
      ..writeByte(10)
      ..write(obj.price)
      ..writeByte(11)
      ..write(obj.paidDeposit)
      ..writeByte(12)
      ..write(obj.amount)
      ..writeByte(13)
      ..write(obj.personName)
      ..writeByte(14)
      ..write(obj.phone3)
      ..writeByte(15)
      ..write(obj.phone4)
      ..writeByte(16)
      ..write(obj.email)
      ..writeByte(17)
      ..write(obj.tradeName)
      ..writeByte(18)
      ..write(obj.trnNumber)
      ..writeByte(19)
      ..write(obj.authPersonName)
      ..writeByte(20)
      ..write(obj.salePersonId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCreateCustomerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
