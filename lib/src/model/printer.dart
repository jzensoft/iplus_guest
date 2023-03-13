import 'package:hive/hive.dart';

part 'printer.g.dart';

@HiveType(typeId: 5)
class Printer extends HiveObject {
  @HiveField(0)
  late String? ipAddress;

  @HiveField(1)
  late String? bdAddress;

  @HiveField(2)
  late String? macAddress;

  @HiveField(3)
  late String? model;

  @HiveField(4)
  late String? series;

  @HiveField(5)
  late String? target;

  @HiveField(6)
  late String? type;
}
