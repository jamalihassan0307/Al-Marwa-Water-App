// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_products_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductsModelHiveAdapter extends TypeAdapter<ProductsModelHive> {
  @override
  final int typeId = 2;

  @override
  ProductsModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductsModelHive(
      name: fields[0] as String,
      description: fields[1] as String,
      price: fields[2] as String,
      id: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProductsModelHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
