import 'dart:developer';
import 'dart:typed_data';

import 'package:epson_epos/epson_epos.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';
import 'package:iplus_guest/src/model/printer.dart';
import 'package:iplus_guest/src/model/project.dart';
import 'package:iplus_guest/src/model/user.dart';
import 'package:iplus_guest/src/utils/boxes.dart';

import 'toast_util.dart';

class PrintUtil {
  EpsonPrinterModel? getPrinter() {
    final printerBox = Boxes.getPrinter();
    final List<Printer> printers = [];
    for (var item in printerBox.values.toList()) {
      printers.add(item);
    }
    if (printers.isNotEmpty) {
      EpsonPrinterModel epsonPrinterModel = EpsonPrinterModel();
      epsonPrinterModel.ipAddress = printers.elementAt(0).ipAddress;
      epsonPrinterModel.bdAddress = printers.elementAt(0).bdAddress;
      epsonPrinterModel.macAddress = printers.elementAt(0).macAddress;
      epsonPrinterModel.model = printers.elementAt(0).model;
      epsonPrinterModel.series = printers.elementAt(0).series;
      epsonPrinterModel.target = printers.elementAt(0).target;
      epsonPrinterModel.type = printers.elementAt(0).type;
      return epsonPrinterModel;
    }
    return null;
  }

  Project? getProjectData() {
    final projectBox = Boxes.getProject();
    final List<Project> projects = [];
    for (var item in projectBox.values.toList()) {
      projects.add(item);
    }
    if (projects.isNotEmpty) {
      return projects.elementAt(0);
    }
    return null;
  }

  printData(User user) async {
    try {
      EpsonPrinterModel? printer = getPrinter();
      Project? project = getProjectData();
      if (printer != null) {
        EpsonEPOSCommand command = EpsonEPOSCommand();
        List<Map<String, dynamic>> commands = [];
        //commands.add(command.addTextAlign(EpsonEPOSTextAlign.LEFT));
        commands.add(command.addFeedLine(4));
        //commands.add(command.append('PRINT TESTE OK!\n'));
        commands.add(command
            .rawData(Uint8List.fromList(await _createData(project, user))));
        commands.add(command.addFeedLine(4));
        commands.add(command.addCut(EpsonEPOSCut.CUT_FEED));
        await EpsonEPOS.onPrint(printer, commands);
      } else {
        showToastError("Not found printer");
      }
    } catch (e) {
      log('$e');
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
      ..target = data.target
      ..type = data.type;
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

  Future<List<int>> _createData(Project? project, User user) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    final formatter = DateFormat('d MMMM yyyy');
    final now = DateTime.now();
    final newDate = DateTime(now.year + 543, now.month, now.day);

    List<int> bytes = [];

    if (project != null) {
      bytes += generator.text("${project.villageName}",
          styles: const PosStyles(bold: true));
    }

    bytes += generator.text("บัตรผู้มาติดต่อ",
        styles: const PosStyles(
            bold: true,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            codeTable: 'CP1252'));
    bytes += generator.text("วันที่ : ${formatter.format(newDate)}",
        styles: const PosStyles(codeTable: 'CP1252'));
    bytes += generator.text("ชื่อ-นามสกุล : ${user.fullName}",
        styles: const PosStyles(codeTable: 'CP1252'));
    bytes += generator.text("ทะเบียนรถ : ${user.vehicleRegistration}",
        styles: const PosStyles(codeTable: 'CP1252'));
    bytes += generator.text("เบอร์ติดต่อ : ${user.other}",
        styles: const PosStyles(codeTable: 'CP1252'));
    bytes += generator.text("ติดต่อบ้านเลขที่ : ${user.houseNumber}",
        styles: const PosStyles(codeTable: 'CP1252'));
    bytes += generator.text(
        "เวลาเข้า : ${DateFormat.Hms().format(user.inTime!)} น.",
        styles: const PosStyles(codeTable: 'CP1252'));
    bytes += generator.text("รายละเอียด",
        styles: const PosStyles(bold: true, codeTable: 'CP1252'));
    bytes += generator.text("สำหรับเจ้าของบ้าน",
        styles: const PosStyles(
            bold: true, align: PosAlign.center, codeTable: 'CP1252'));
    bytes += generator.feed(5);
    bytes += generator.emptyLines(2);
    bytes += generator.text(
        "กรุณาให้เจ้าของบ้านประทับตรายางหรือเซ็นต์ชื่อ กำกับทุกครั้ง",
        styles: const PosStyles(bold: true, codeTable: 'CP1252'));

    bytes += generator.reset();
    bytes += generator.cut();
    return bytes;
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
