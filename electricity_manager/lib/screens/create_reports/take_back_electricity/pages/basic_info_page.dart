import 'package:electricity_manager/app_bloc/bloc.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/models/user.dart';
import 'package:electricity_manager/screens/components/fields/dropdown_field.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:electricity_manager/screens/components/app_field.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BasicInfoPage extends StatefulWidget {
  const BasicInfoPage(
      {Key? key, required this.nextCallback, required this.staffs})
      : super(key: key);

  final Function(String, String, String, List<UserProfile>) nextCallback;
  final List<UserProfile> staffs;

  @override
  _BasicInfoPageState createState() => _BasicInfoPageState();
}

class _BasicInfoPageState extends State<BasicInfoPage> {
  final _appBloc = getIt.get<AppBloc>();

  final _clientCodeCtrl = TextEditingController();
  final _clientNameCtrl = TextEditingController();
  final _clientAddressCtrl = TextEditingController();

  final _clientCodeNode = FocusNode();
  final _clientNameNode = FocusNode();
  final _clientAddressNode = FocusNode();

  late TextEditingController _staffName1Ctrl;
  final _staffName2Ctrl = TextEditingController();

  UserProfile? _staff2;
  late UserProfile _user;

  final _formKey = GlobalKey<FormState>();

  void _next() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      widget.nextCallback(
          _clientCodeCtrl.text.trim(),
          _clientNameCtrl.text.trim(),
          _clientAddressCtrl.text.trim(),
          [_user, if (_staff2 != null) _staff2!]);
    }
  }

  @override
  void initState() {
    super.initState();
    _user = _appBloc.user!.profile!;

    _staffName1Ctrl =
        TextEditingController(text: '${_user.fullName} (${_user.roleString})');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              'Thu hồi công tơ',
              style: titleWhite.copyWith(fontSize: 20.sp),
            ),
            SizedBox(
              height: 4.w,
            ),
            Text(
              'Thông tin cơ bản',
              style: caption.copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingButtonWidget(
        onPressed: _next,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _clientInfo(),
              SizedBox(
                height: 24.w,
              ),
              _staffInfo()
            ],
          ),
        ),
      ),
    );
  }

  Widget _clientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin khách hàng'.toUpperCase(),
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        SizedBox(
          height: 8.w,
        ),
        AppField(
          controller: _clientCodeCtrl,
          label: 'Mã khách hàng:',
          autoFocus: true,
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
    );
  }

  Widget _staffInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin nhân viên'.toUpperCase(),
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        SizedBox(
          height: 8.w,
        ),
        _currentStaff(),
        if (widget.staffs.isNotEmpty) _addStaff()
      ],
    );
  }

  Widget _currentStaff() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8.w,
        ),
        Text('Nhân viên 1:'),
        AppField(
          controller: _staffName1Ctrl,
          isName: true,
          enable: false,
          hintText: 'Nhập tên nhân viên',
        ),
      ],
    );
  }

  Widget _addStaff() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nhân viên 2:'),
        SizedBox(
          height: 8.w,
        ),
        DropDownField<UserProfile>(
          controller: _staffName2Ctrl,
          titleSelection: 'Chọn nhân viên',
          isRequired: false,
          data: widget.staffs,
          initial: _staff2,
          selected: (item) {
            setState(() {
              _staff2 = item;
            });
          },
        ),
      ],
    );
  }
}
