import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 3)
class User extends HiveObject {
  @HiveField(0)
  late String fullName;

  @HiveField(1)
  late String vehicleRegistration;

  @HiveField(2)
  late String houseNumber;

  @HiveField(3)
  late String? other;

  @HiveField(4)
  late bool isOut = false;

  @HiveField(5)
  late bool isPrinted = false;

  @HiveField(6)
  late DateTime? inTime;

  @HiveField(7)
  late DateTime? outTime;

  @HiveField(8)
  late DateTime? printTime;

  @HiveField(9)
  late String? idNumber;
}
