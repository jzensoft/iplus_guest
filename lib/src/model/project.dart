import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 4)
class Project extends HiveObject {
  @HiveField(0)
  late String? villageName;

  @HiveField(1)
  late String? villageNumber;

  @HiveField(2)
  late String? alley;

  @HiveField(3)
  late String? subDistrict;

  @HiveField(4)
  late String? district;

  @HiveField(5)
  late String? province;

  @HiveField(6)
  late String? telephone;
}
