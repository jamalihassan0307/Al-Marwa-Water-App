// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_pay_type_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PayTypeHiveAdapter extends TypeAdapter<PayTypeHive> {
  @override
  final int typeId = 3;

  @override
  PayTypeHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PayTypeHive(
      name: fields[0] as String,
      status: fields[1] as String,
      id: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PayTypeHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayTypeHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
