import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:electricity_manager/screens/components/app_field.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputInfoPage extends StatefulWidget {
  const InputInfoPage({Key? key, required this.nextCallback}) : super(key: key);

  final Function(String, String, String, String) nextCallback;

  @override
  _InputInfoPageState createState() => _InputInfoPageState();
}

class _InputInfoPageState extends State<InputInfoPage> {
  final _staffNameCtrl = TextEditingController(text: 'Nguyễn Đức Toàn');
  final _clientCodeCtrl = TextEditingController();
  final _clientNameCtrl = TextEditingController();
  final _clientAddressCtrl = TextEditingController();

  final _staffNameNode = FocusNode();
  final _clientCodeNode = FocusNode();
  final _clientNameNode = FocusNode();
  final _clientAddressNode = FocusNode();

  final _formKey = GlobalKey<FormState>(debugLabel: 'info');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Thông tin cơ bản',
          style: titleWhite.copyWith(fontSize: 22.sp),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingButtonWidget(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            FocusScope.of(context).unfocus();
            widget.nextCallback(
                _staffNameCtrl.text.trim(),
                _clientCodeCtrl.text.trim(),
                _clientNameCtrl.text.trim(),
                _clientAddressCtrl.text.trim());
          }
        },
        label: 'Tiếp tục',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppField(
                enable: false,
                controller: _staffNameCtrl,
                fcNode: _staffNameNode,
                nextFcNode: _clientCodeNode,
                isName: true,
                autoFocus: true,
                textInputAction: TextInputAction.next,
                label: 'Tên nhân viên:',
                hintText: 'Nhập tên nhân viên',
              ),
              AppField(
                controller: _clientCodeCtrl,
                label: 'Mã khách hàng:',
                fcNode: _clientCodeNode,
                nextFcNode: _clientNameNode,
                textInputAction: TextInputAction.next,
                hintText: 'Nhập mã khách hàng',
              ),
              AppField(
                controller: _clientNameCtrl,
                label: 'Tên khách hàng:',
                isName: true,
                fcNode: _clientNameNode,
                nextFcNode: _clientAddressNode,
                textInputAction: TextInputAction.next,
                hintText: 'Nhập tên khách hàng',
              ),
              AppField(
                controller: _clientAddressCtrl,
                textInputAction: TextInputAction.done,
                fcNode: _clientAddressNode,
                isName: true,
                label: 'Địa chỉ khách hàng:',
                hintText: 'Nhập địa chỉ khách hàng',
              )
            ],
          ),
        ),
      ),
    );
  }
}
