import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'package:iplus_guest/src/model/user.dart';
import 'package:iplus_guest/src/pages/setting_page.dart';
import 'package:iplus_guest/src/utils/boxes.dart';
import 'package:iplus_guest/src/utils/print_util.dart';
import 'package:iplus_guest/src/widgets/clip.dart';
import 'package:iplus_guest/src/widgets/paint.dart';

import '../constants/api.dart';
import 'printer_page.dart';

class InPage extends StatefulWidget {
  final VoidCallback onSaved;

  const InPage({Key? key, required this.onSaved}) : super(key: key);

  @override
  State<InPage> createState() => _InPageState();
}

class _InPageState extends State<InPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _vehicleRegistrationController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _otherController = TextEditingController();

  late List<CameraDescription> _cameras;
  late CameraController _cameraController;

  bool _isCameraMode = false;
  String _idNumber = "";

  final _sizeBox = const SizedBox(
    height: 20,
  );

  @override
  void dispose() {
    _nameController.dispose();
    _vehicleRegistrationController.dispose();
    _houseNumberController.dispose();
    _otherController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "บันทึกการเข้า",
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PrinterPage(),
                  ),
                );
              },
              child: const Icon(Icons.print),
            ),
          ),
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
      body: !_isCameraMode ? _buildForm(context) : _buildCameraPreview(),
    );
  }

  SingleChildScrollView _buildForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sizeBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "บันทึกการเข้า",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  _sizeBox,
                  _buildName(),
                  _sizeBox,
                  _buildVehicleRegistration(),
                  _sizeBox,
                  _buildHouseNumber(),
                  _sizeBox,
                  _buildOther(),
                  _sizeBox,
                  _buildButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SafeArea _buildCameraPreview() {
    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              foregroundPainter: Paint(),
              child: CameraPreview(_cameraController),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ClipPath(
              clipper: Clip(),
              child: CameraPreview(_cameraController),
            ),
          ),
          Positioned(
            bottom: 30.0,
            left: 10.0,
            right: 10.0,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _handleTakePicture(true);
                    },
                    icon: const Icon(Icons.card_membership_outlined),
                    label: const Text("บัตร ปชช."),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _handleTakePicture(false);
                    },
                    icon: const Icon(Icons.car_rental_outlined),
                    label: const Text("ทะเบียนรถ"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _buildCameraButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _startCamera,
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text("Detect Card"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _buildButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _handleSave(
                    _nameController.text.toString(),
                    _vehicleRegistrationController.text.toString(),
                    _houseNumberController.text.toString(),
                    _otherController.text.toString());
              }
            },
            label: const Text("บันทึก"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _startCamera,
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text("Detect Card"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildOther() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _otherController,
          maxLength: 30,
          decoration: const InputDecoration(
            labelText: "อื่นๆ เพิ่มเติม",
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Column _buildHouseNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _houseNumberController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: 20,
          decoration: const InputDecoration(
            labelText: "ติดต่อ บ้านเลขที่",
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "กรุณา ป้อนบ้านเลขที่ติดต่อ";
            }
            return null;
          },
        )
      ],
    );
  }

  Column _buildVehicleRegistration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _vehicleRegistrationController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: 50,
          decoration: const InputDecoration(
            labelText: "ทะเบียนรถ",
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "กรุณา ป้อนทะเบียนรถ";
            }
            return null;
          },
        )
      ],
    );
  }

  Column _buildName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _nameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            labelText: "ชื่อ นามสกุล",
            border: OutlineInputBorder(),
          ),
          maxLength: 250,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "กรุณา ป้อนชื่อ-นามสกุล";
            }
            return null;
          },
        )
      ],
    );
  }

  void _startCamera() async {
    _cameras = await availableCameras();
    _cameraController =
        CameraController(_cameras[0], ResolutionPreset.veryHigh);
    await _cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isCameraMode = true;
      });
    }).catchError((err) {
      debugPrint(err);
    });
  }

  void _handleTakePicture(bool isDetectCard) async {
    _cameraController.takePicture().then((XFile? file) async {
      if (mounted) {
        if (file != null) {
          _showLoaderDialog(context);
          _cameraController.pausePreview();
          _uploadImage(isDetectCard, file);
          setState(() {
            _isCameraMode = false;
          });
        }
      }
    });
  }

  void _uploadImage(bool isIdCard, XFile file) async {
    final img.Image? capturedImage =
        img.decodeImage(await File(file.path).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    await File(file.path).writeAsBytes(img.encodeJpg(orientedImage));

    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(file.path);

    int x = 0;
    int y = (properties.height! / 3).round();
    int width = (properties.width!).round();
    int height = 800;

    File croppedFile =
        await FlutterNativeImage.cropImage(file.path, x, y, width, height);

    File originalFile = croppedFile;

    String filePath = originalFile.path;
    String fileName = file.name;

    var formData = FormData.fromMap(
      {
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: MediaType(
            'image',
            'jpeg',
          ),
        )
      },
    );

    var res = await Dio().post(
      isIdCard ? API.detectIdCard : API.detectLicense,
      data: formData,
      options: Options(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        headers: {
          'Apikey': API.aiForThaiKey,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    if (res.statusCode == 200) {
      setState(() {
        if (!isIdCard) {
          _vehicleRegistrationController.text =
              "${res.data["r_char"]} ${res.data["r_digit"]}";
        } else {
          _nameController.text = res.data["th_name"];
          _idNumber = res.data["id_number"];
        }
      });
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "การตรวจสอบล้มเหลว กรุณราลองอีกครั้ง",
            ),
          ),
        );
      }
    }
  }

  void _showLoaderDialog(BuildContext context) {
    var alertDialog = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text(
              "Loading...",
            ),
          ),
        ],
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void _handleSave(String name, String vehicleRegistration, String houseNumber,
      String other) async {
    final User user = User()
      ..fullName = name
      ..vehicleRegistration = vehicleRegistration
      ..houseNumber = houseNumber
      ..other = other
      ..inTime = DateTime.now()
      ..outTime = null
      ..printTime = null
      ..idNumber = _idNumber;
    final box = Boxes.getUser();
    box.add(user);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "บันทึกเรียบร้อย",
          ),
        ),
      );
      widget.onSaved();
    }
    await PrintUtil().printData(user);
  }
}
