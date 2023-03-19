import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:iplus_guest/src/model/printer.dart';
import 'package:iplus_guest/src/model/project.dart';
import 'package:iplus_guest/src/model/user.dart';
import 'package:iplus_guest/src/pages/launcher.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProjectAdapter());
  Hive.registerAdapter(PrinterAdapter());
  await Hive.openBox<User>('user');
  await Hive.openBox<Project>('project');
  await Hive.openBox<Printer>('printer');

  Intl.defaultLocale = 'th';
  initializeDateFormatting();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const Launcher(),
    );
  }
}
