import 'dart:developer';
import 'dart:typed_data';

import 'package:epson_epos/epson_epos.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';

class BlueTooth extends StatefulWidget {
  const BlueTooth({Key? key}) : super(key: key);

  @override
  State<BlueTooth> createState() => _BlueToothState();
}

class _BlueToothState extends State<BlueTooth> {
  List<EpsonPrinterModel> printers = [];

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
        title: const Text('Printer settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: onDiscoveryTCP,
                    child: const Text("Search Printer"),
                  )
                ],
              ),
              Flexible(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    final printer = printers[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      title: Text('${printer.ipAddress}'),
                      subtitle: TextButton(
                        onPressed: () {
                          onPrintTest(printer);
                        },
                        child: const Text(
                          'Print test',
                        ),
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
    try {
      List<EpsonPrinterModel>? data =
          await EpsonEPOS.onDiscovery(type: EpsonEPOSPortType.TCP);
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

  void onSetPrinterSetting(EpsonPrinterModel printer) async {
    try {
      await EpsonEPOS.setPrinterSetting(printer, paperWidth: 80);
    } catch (e) {
      log("Error: $e");
    }
  }

  Future<List<int>> _customEscPos() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    bytes += generator.text('Special 1: ???? ???? ???? ???? ???? ???? ????',
        styles: const PosStyles(codeTable: 'CP1252'));
    bytes += generator.text('Special 2: bl??b??rgr??d',
        styles: const PosStyles(codeTable: 'CP1252'));

    bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
    bytes +=
        generator.text('Reverse text', styles: const PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: const PosStyles(underline: true), linesAfter: 1);
    bytes += generator.text('Align left',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: const PosStyles(align: PosAlign.right), linesAfter: 1);
    bytes += generator.qrcode('Barcode by escpos',
        size: QRSize.Size4, cor: QRCorrection.H);
    bytes += generator.feed(2);

    bytes += generator.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: const PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    bytes += generator.text('Text size 200%',
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    bytes += generator.reset();
    bytes += generator.cut();

    return bytes;
  }

  void onPrintTest(EpsonPrinterModel printer) async {
    EpsonEPOSCommand command = EpsonEPOSCommand();
    List<Map<String, dynamic>> commands = [];
    commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
    commands.add(command.addFeedLine(4));
    commands.add(command.append('PRINT TESTE OK!\n'));
    commands.add(command.rawData(Uint8List.fromList(await _customEscPos())));
    commands.add(command.addFeedLine(4));
    commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
    await EpsonEPOS.onPrint(printer, commands);
  }
}
