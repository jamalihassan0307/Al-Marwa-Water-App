// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_create_bill_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveCreateBillModelAdapter extends TypeAdapter<HiveCreateBillModel> {
  @override
  final int typeId = 5;

  @override
  HiveCreateBillModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveCreateBillModel(
      date: fields[0] as String,
      customerId: fields[1] as int,
      productId: fields[2] as int,
      trn: fields[3] as String,
      vat: fields[4] as String,
      quantity: fields[5] as String,
      rate: fields[6] as String,
      amount: fields[7] as String,
      saleUserId: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiveCreateBillModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.customerId)
      ..writeByte(2)
      ..write(obj.productId)
      ..writeByte(3)
      ..write(obj.trn)
      ..writeByte(4)
      ..write(obj.vat)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.rate)
      ..writeByte(7)
      ..write(obj.amount)
      ..writeByte(8)
      ..write(obj.saleUserId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveCreateBillModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
