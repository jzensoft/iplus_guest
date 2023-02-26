// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 4;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project()
      ..villageName = fields[0] as String?
      ..villageNumber = fields[1] as String?
      ..alley = fields[2] as String?
      ..subDistrict = fields[3] as String?
      ..district = fields[4] as String?
      ..province = fields[5] as String?
      ..telephone = fields[6] as String?;
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.villageName)
      ..writeByte(1)
      ..write(obj.villageNumber)
      ..writeByte(2)
      ..write(obj.alley)
      ..writeByte(3)
      ..write(obj.subDistrict)
      ..writeByte(4)
      ..write(obj.district)
      ..writeByte(5)
      ..write(obj.province)
      ..writeByte(6)
      ..write(obj.telephone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
