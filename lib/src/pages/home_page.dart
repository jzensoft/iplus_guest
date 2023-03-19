import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iplus_guest/src/model/user.dart';
import 'package:iplus_guest/src/pages/setting_page.dart';
import 'package:iplus_guest/src/widgets/item.dart';
import 'package:iplus_guest/src/widgets/not_fount_data.dart';
import 'package:iplus_guest/src/widgets/user_dialog.dart';

import '../utils/boxes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("ประวัติการเข้า-ออก โครงการ"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingPage(),
                  ),
                );
              },
              child: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<User>>(
        valueListenable: Boxes.getUser().listenable(),
        builder: (context, box, _) {
          final usersIn = box.values
              .toList()
              .cast<User>()
              .where((user) => !user.isOut)
              .toList();
          final usersOut = box.values
              .toList()
              .cast<User>()
              .where((user) => user.isOut)
              .toList();

          final List<User> users = List.from(usersIn.reversed)
            ..addAll(List.from(usersOut.reversed));
          return buildContent(users);
        },
      ),
    );
  }

  Widget buildContent(List<User> users) {
    if (users.isEmpty) {
      return const NotFoundData();
    }
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          "ประวัติการเข้า-ออก โครงการ",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = users[index];
              return Item(
                onConfirm: _showConfirmDialog,
                user: user,
              );
            },
          ),
        ),
      ],
    );
  }

  void _showConfirmDialog(User user) {
    UserConfirmDialog(
      cancelText: "ยกเลิก",
      confirmText: "ยืนยัน",
      context: context,
      text1: "คุณต้องการยืนยันการออกของลูกบ้าน ",
      text2: " ใช่หรือไม่?",
      title: "ยืนยันการออก",
      user: user,
      onConfirm: () {
        user.outTime = DateTime.now();
        user.isOut = true;
        user.save();
        Navigator.of(context).pop();
      },
    );
  }
}
