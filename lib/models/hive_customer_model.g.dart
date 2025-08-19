// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_customer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerDataHiveAdapter extends TypeAdapter<CustomerDataHive> {
  @override
  final int typeId = 1;

  @override
  CustomerDataHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerDataHive(
      name: fields[0] as String?,
      phone: fields[1] as String?,
      id: fields[2] as int?,
      trn: fields[3] as String?,
      customerCode: fields[4] as String?,
      buildingName: fields[5] as String?,
      blockNo: fields[6] as String?,
      price: fields[8] as String?,
      roomNo: fields[7] as String?,
      tradeName: fields[9] as String?,
      authPersonName: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerDataHive obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.trn)
      ..writeByte(4)
      ..write(obj.customerCode)
      ..writeByte(5)
      ..write(obj.buildingName)
      ..writeByte(6)
      ..write(obj.blockNo)
      ..writeByte(7)
      ..write(obj.roomNo)
      ..writeByte(8)
      ..write(obj.price)
      ..writeByte(9)
      ..write(obj.tradeName)
      ..writeByte(10)
      ..write(obj.authPersonName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerDataHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
