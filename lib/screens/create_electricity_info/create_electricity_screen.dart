import 'package:electricity_manager/models/report_model.dart';
import 'package:electricity_manager/screens/create_electricity_info/confirm_info_screen.dart';
import 'package:flutter/material.dart';

import 'pages/additional_page.dart';
import 'pages/cong_to_thao_page.dart';
import 'pages/cong_to_treo_page.dart';
import 'pages/input_info_page.dart';

class CreateElectricityScreen extends StatefulWidget {
  const CreateElectricityScreen({Key? key}) : super(key: key);

  @override
  _CreateElectricityScreenState createState() =>
      _CreateElectricityScreenState();
}

class _CreateElectricityScreenState extends State<CreateElectricityScreen> {
  int _index = 0;

  ReportModel _reportModel = ReportModel();

  void _nextStep() {
    setState(() {
      _index++;
    });
  }

  void _backStep() {
    setState(() {
      _index--;
    });
  }

  void _finishStep() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          InputInfoPage(
            nextCallback: (staffName, clientCode, clientName, clientAddress) {
              _reportModel.setInfo(
                  staffName, clientCode, clientName, clientAddress);
              _nextStep();
            },
          ),
          CongToThaoPage(
            nextCallback: (maCongTo, soCongTo, chiSoThao, pictures) {
              _reportModel.setCongToThao(
                  maCongTo, soCongTo, chiSoThao, pictures);
              _nextStep();
            },
            backCallback: _backStep,
          ),
          CongToTreoPage(
            nextCallback: (maCongTo, soCongTo, chiSoThao, temKiemDinh,
                ngayKiemDinh, pictures) {
              _reportModel.setCongToTreo(maCongTo, soCongTo, chiSoThao,
                  temKiemDinh, ngayKiemDinh, pictures);
              _nextStep();
            },
            backCallback: _backStep,
          ),
          AdditionalPage(
            nextCallback: (signPicture) {
              _reportModel.anhChuKy = signPicture;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ConfirmInfoScreen(
                            reportModel: _reportModel,
                          )));
            },
            backCallback: _finishStep,
          )
        ],
      ),
    );
  }
}
