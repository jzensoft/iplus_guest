// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrinterAdapter extends TypeAdapter<Printer> {
  @override
  final int typeId = 5;

  @override
  Printer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Printer()
      ..ipAddress = fields[0] as String?
      ..bdAddress = fields[1] as String?
      ..macAddress = fields[2] as String?
      ..model = fields[3] as String?
      ..series = fields[4] as String?
      ..target = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, Printer obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.ipAddress)
      ..writeByte(1)
      ..write(obj.bdAddress)
      ..writeByte(2)
      ..write(obj.macAddress)
      ..writeByte(3)
      ..write(obj.model)
      ..writeByte(4)
      ..write(obj.series)
      ..writeByte(5)
      ..write(obj.target);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrinterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
