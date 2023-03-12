import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iplus_guest/src/pages/home_page.dart';
import 'package:iplus_guest/src/pages/in_page.dart';
import 'package:iplus_guest/src/pages/out_page.dart';

class Launcher extends StatefulWidget {
  const Launcher({Key? key}) : super(key: key);

  @override
  State<Launcher> createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  int _selectedIndex = 0;
  late List<Widget> _pageWidget;

  final List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "หน้าหลัก"),
    const BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "เข้า"),
    const BottomNavigationBarItem(icon: Icon(Icons.outbox), label: "ออก")
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _initPage() {
    _pageWidget = <Widget>[
      const HomePage(),
      InPage(onSaved: () {
        _onItemTapped(_selectedIndex);
      }),
      const OutPage(),
    ];
  }

  @override
  void initState() {
    _initPage();
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: _pageWidget.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: _menuBar,
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
