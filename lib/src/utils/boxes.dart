import 'package:hive/hive.dart';

import '../model/printer.dart';
import '../model/project.dart';
import '../model/user.dart';

class Boxes {
  static Box<User> getUser() => Hive.box<User>('user');

  static Box<Project> getProject() => Hive.box<Project>('project');

  static Box<Printer> getPrinter() => Hive.box<Printer>('printer');
}
