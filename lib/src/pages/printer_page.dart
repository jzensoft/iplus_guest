import 'dart:developer';

import 'package:epson_epos/epson_epos.dart';
import 'package:flutter/material.dart';

import '../utils/print_util.dart';

class PrinterPage extends StatefulWidget {
  const PrinterPage({Key? key}) : super(key: key);

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  List<EpsonPrinterModel> printers = [];
  String _textSearch = "ค้นหา";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    onDiscoveryTCP();
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Printer'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: onDiscoveryTCP,
                    child: Text(_textSearch),
                  )
                ],
              ),
              const Divider(
                color: Colors.grey,
              ),
              Flexible(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final printer = printers[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(Icons.print),
                      title: Text('${printer.series}'),
                      subtitle: Text('${printer.ipAddress}'),
                      trailing: TextButton(
                        onPressed: () {
                          PrintUtil().printTest(printer);
                        },
                        child: const Text('ทดสอบ'),
                      ),
                    );
                  },
                  itemCount: printers.length,
                  primary: false,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onDiscoveryTCP() async {
    setState(() {
      _textSearch = "กำลังค้นหา...";
    });
    try {
      List<EpsonPrinterModel>? data =
          await EpsonEPOS.onDiscovery(type: EpsonEPOSPortType.TCP);
      if (data != null && data.isNotEmpty) {
        for (var element in data) {
          print(element.toJson());
        }
        setState(() {
          _textSearch = "ค้นหา";
          printers = data;
        });
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  onDiscoveryUSB() async {
    try {
      List<EpsonPrinterModel>? data =
          await EpsonEPOS.onDiscovery(type: EpsonEPOSPortType.USB);
      if (data != null && data.isNotEmpty) {
        for (var element in data) {
          print(element.toJson());
        }
        setState(() {
          printers = data;
        });
      }
    } catch (e) {
      log("Error: $e");
    }
  }
}
