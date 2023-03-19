import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/src/model/project.dart';
import '../utils/boxes.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _formKey = GlobalKey<FormState>();
  final _villageNameController = TextEditingController();
  final _villageNumberController = TextEditingController();
  final _alleyController = TextEditingController();
  final _subDistrictController = TextEditingController();
  final _districtController = TextEditingController();
  final _provinceController = TextEditingController();
  final _telephoneController = TextEditingController();

  Project? project;

  final _sizeBox = const SizedBox(
    height: 20,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("ตั้งค่า"),
      ),
      body: ValueListenableBuilder<Box<Project>>(
        valueListenable: Boxes.getProject().listenable(),
        builder: (context, box, _) {
          final projects = box.values.toList().cast<Project>();
          return _buildContent(projects.isNotEmpty ? projects[0] : null);
        },
      ),
    );
  }

  Widget _buildContent(Project? project) {
    if (project != null) {
      this.project = project;
      _villageNameController.text = project.villageName ?? "-";
      _villageNumberController.text = project.villageNumber ?? "-";
      _alleyController.text = project.alley ?? "-";
      _subDistrictController.text = project.subDistrict ?? "-";
      _districtController.text = project.district ?? "-";
      _provinceController.text = project.province ?? "-";
      _telephoneController.text = project.telephone ?? "-";
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _sizeBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "ข้อมูลโครงการ",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
              _sizeBox,
              _buildVillageName(),
              _sizeBox,
              _buildVillageNumber(),
              _sizeBox,
              _buildAlley(),
              _sizeBox,
              _buildSubDistrict(),
              _sizeBox,
              _buildDistrict(),
              _sizeBox,
              _buildProvince(),
              _sizeBox,
              _buildTelephone(),
              _sizeBox,
              _buildButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildVillageName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _villageNameController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            labelText: "ชื่อหมู่บ้าน",
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "กรุณา ชื่อหมู่บ้าน";
            }
            return null;
          },
        )
      ],
    );
  }

  Column _buildVillageNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _villageNumberController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            labelText: "เลขที่/หมู่ที่",
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "กรุณา เลขที่/หมู่ที่";
            }
            return null;
          },
        )
      ],
    );
  }

  Column _buildAlley() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _alleyController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            labelText: "ซอย/ถนน",
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "กรุณา ซอย/ถนน";
            }
            return null;
          },
        )
      ],
    );
  }

  Column _buildSubDistrict() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _subDistrictController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            labelText: "ตำบล/แขวง",
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "กรุณา ตำบล/แขวง";
            }
            return null;
          },
        )
      ],
    );
  }

  Column _buildDistrict() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _districtController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            labelText: "อำเภอ/เขต",
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "กรุณา อำเภอ/เขต";
            }
            return null;
          },
        )
      ],
    );
  }

  Column _buildProvince() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _provinceController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            labelText: "จังหวัด",
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "กรุณา จังหวัด";
            }
            return null;
          },
        )
      ],
    );
  }

  Column _buildTelephone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _telephoneController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            labelText: "เบอร์ติดต่อ",
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "กรุณา เบอร์ติดต่อ";
            }
            return null;
          },
        )
      ],
    );
  }

  Row _buildButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: Icon(project == null ? Icons.save : Icons.edit),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _handleSaveProject(
                    _villageNameController.text,
                    _villageNumberController.text,
                    _alleyController.text,
                    _subDistrictController.text,
                    _districtController.text,
                    _provinceController.text,
                    _telephoneController.text);
              }
            },
            label: Text(project == null ? "บันทึก" : "แก้ไขข้อมูล"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSaveProject(
      String villageName,
      String villageNumber,
      String alley,
      String subDistrict,
      String district,
      String province,
      String telephone) {
    if (project != null) {
      project?.villageName = villageName;
      project?.villageNumber = villageNumber;
      project?.alley = alley;
      project?.subDistrict = subDistrict;
      project?.district = district;
      project?.province = province;
      project?.telephone = telephone;
      project?.save();
    } else {
      final Project project = Project()
        ..villageName = villageName
        ..villageNumber = villageNumber
        ..alley = alley
        ..subDistrict = subDistrict
        ..district = district
        ..province = province
        ..telephone = telephone;

      final box = Boxes.getProject();
      box.add(project);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          project == null ? "บันทึกเรียบร้อย" : "แก้ไขข้อมูลเรียบร้อย",
        ),
      ),
    );
    Navigator.of(context).pop();
  }
}
