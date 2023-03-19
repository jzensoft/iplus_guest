import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iplus_guest/src/pages/setting_page.dart';

import '../model/user.dart';
import '../utils/boxes.dart';
import '../widgets/item.dart';
import '../widgets/not_fount_data.dart';

class OutPage extends StatefulWidget {
  const OutPage({Key? key}) : super(key: key);

  @override
  State<OutPage> createState() => _OutPageState();
}

class _OutPageState extends State<OutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("ประวัติการออก โครงการ"),
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
          final users = box.values
              .toList()
              .cast<User>()
              .where((user) => user.isOut)
              .toList();
          return buildContent(List.from(users.reversed));
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
          "ประวัติการออก โครงการ",
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
                onConfirm: (data) {},
                user: user,
                isIn: false,
              );
            },
          ),
        ),
      ],
    );
  }
}
