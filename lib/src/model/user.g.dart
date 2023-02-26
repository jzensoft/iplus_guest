// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 3;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User()
      ..fullName = fields[0] as String
      ..vehicleRegistration = fields[1] as String
      ..houseNumber = fields[2] as String
      ..other = fields[3] as String?
      ..isOut = fields[4] as bool
      ..isPrinted = fields[5] as bool
      ..inTime = fields[6] as DateTime?
      ..outTime = fields[7] as DateTime?
      ..printTime = fields[8] as DateTime?
      ..idNumber = fields[9] as String?;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.fullName)
      ..writeByte(1)
      ..write(obj.vehicleRegistration)
      ..writeByte(2)
      ..write(obj.houseNumber)
      ..writeByte(3)
      ..write(obj.other)
      ..writeByte(4)
      ..write(obj.isOut)
      ..writeByte(5)
      ..write(obj.isPrinted)
      ..writeByte(6)
      ..write(obj.inTime)
      ..writeByte(7)
      ..write(obj.outTime)
      ..writeByte(8)
      ..write(obj.printTime)
      ..writeByte(9)
      ..write(obj.idNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
