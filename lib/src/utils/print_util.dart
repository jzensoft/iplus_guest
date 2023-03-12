import 'dart:developer';

import 'package:epson_epos/epson_epos.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:iplus_guest/src/model/printer.dart';
import 'package:iplus_guest/src/utils/boxes.dart';

import 'toast_util.dart';

class PrintUtil {

  EpsonPrinterModel? getPrinter() {
    final printer = Boxes.getPrinter();
    print(printer.toMap());
    return null;
  }

  printData() async {
    EpsonPrinterModel? printer = getPrinter();
    if (printer != null) {
      EpsonEPOSCommand command = EpsonEPOSCommand();
      List<Map<String, dynamic>> commands = [];
      commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
      commands.add(command.addFeedLine(4));
      commands.add(command.append('PRINT TESTE OK!\n'));
      //commands.add(command.rawData(Uint8List.fromList(await _customEscPos())));
      commands.add(command.addFeedLine(4));
      commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
      await EpsonEPOS.onPrint(printer, commands);
    } else {
      showToastError("Not found printer");
    }
  }

  printTest(EpsonPrinterModel printer) async {
    try {
      EpsonEPOSCommand command = EpsonEPOSCommand();
      List<Map<String, dynamic>> commands = [];
      commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
      commands.add(command.addFeedLine(4));
      commands.add(command.append('PRINT TESTE OK!\n'));
      commands.add(command.append('ทดสอบพิมพ์!\n'));
      commands.add(command.addFeedLine(4));
      commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
      await EpsonEPOS.onPrint(printer, commands);
      savePrinter(printer);
    } catch (e) {
      showToastError("$e");
    }
  }

  void savePrinter(EpsonPrinterModel data) {
    final Printer printer = Printer()
      ..ipAddress = data.ipAddress
      ..bdAddress = data.bdAddress
      ..macAddress = data.macAddress
      ..model = data.model
      ..series = data.series
      ..target = data.target;
    final box = Boxes.getPrinter();
    box.add(printer);
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
    bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: const PosStyles(codeTable: 'CP1252'));
    bytes += generator.text('Special 2: blåbærgrød',
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
}
