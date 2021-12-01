import 'package:electricity_manager/models/user.dart';
import 'package:electricity_manager/screens/components/layout_have_floating_button.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:electricity_manager/screens/components/app_field.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResoleBasicInfoPage extends StatefulWidget {
  const ResoleBasicInfoPage({Key? key, required this.nextCallback})
      : super(key: key);

  final Function(String, String, List<UserProfile>, List<UserProfile>,
      List<UserProfile>) nextCallback;

  @override
  _ResoleBasicInfoPageState createState() => _ResoleBasicInfoPageState();
}

class _ResoleBasicInfoPageState extends State<ResoleBasicInfoPage> {
  final _resolveNameCtrl = TextEditingController();
  final _resolveAddressCtrl = TextEditingController();

  final _electricityUnit1Ctrl = TextEditingController();
  final _electricityUnitRole1Ctrl = TextEditingController();
  final _electricityUnit2Ctrl = TextEditingController();
  final _electricityUnitRole2Ctrl = TextEditingController();

  final _regionUnit1Ctrl = TextEditingController();
  final _regionUnitRole1Ctrl = TextEditingController();
  final _regionUnit2Ctrl = TextEditingController();
  final _regionUnitRole2Ctrl = TextEditingController();

  final _relatedUnit1Ctrl = TextEditingController();
  final _relatedUnitRole1Ctrl = TextEditingController();
  final _relatedUnit2Ctrl = TextEditingController();
  final _relatedUnitRole2Ctrl = TextEditingController();

  final _resolveAddressNode = FocusNode();

  final _electricityUnit1Node = FocusNode();
  final _electricityUnitRole1Node = FocusNode();
  final _electricityUnit2Node = FocusNode();
  final _electricityUnitRole2Node = FocusNode();

  final _regionUnit1Node = FocusNode();
  final _regionUnitRole1Node = FocusNode();
  final _regionUnit2Node = FocusNode();
  final _regionUnitRole2Node = FocusNode();

  final _relatedUnit1Node = FocusNode();
  final _relatedUnitRole1Node = FocusNode();
  final _relatedUnit2Node = FocusNode();
  final _relatedUnitRole2Node = FocusNode();

  final _formKey = GlobalKey<FormState>();

  void _next() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      widget.nextCallback(
          _resolveNameCtrl.text.trim(), _resolveAddressCtrl.text.trim(), [
        UserProfile(
            fullName: _electricityUnit1Ctrl.text.trim(),
            roleName: _electricityUnitRole1Ctrl.text.trim()),
        if (_electricityUnit2Ctrl.text.trim().isNotEmpty &&
            _electricityUnitRole2Ctrl.text.trim().isNotEmpty)
          UserProfile(
              fullName: _electricityUnit2Ctrl.text.trim(),
              roleName: _electricityUnitRole2Ctrl.text.trim()),
      ], [
        UserProfile(
            fullName: _regionUnit1Ctrl.text.trim(),
            roleName: _regionUnitRole1Ctrl.text.trim()),
        if (_regionUnit2Ctrl.text.trim().isNotEmpty &&
            _regionUnitRole2Ctrl.text.trim().isNotEmpty)
          UserProfile(
              fullName: _regionUnit2Ctrl.text.trim(),
              roleName: _regionUnitRole2Ctrl.text.trim()),
      ], [
        UserProfile(
            fullName: _relatedUnit1Ctrl.text.trim(),
            roleName: _relatedUnitRole1Ctrl.text.trim()),
        if (_relatedUnit2Ctrl.text.trim().isNotEmpty &&
            _relatedUnitRole2Ctrl.text.trim().isNotEmpty)
          UserProfile(
              fullName: _relatedUnit2Ctrl.text.trim(),
              roleName: _relatedUnitRole2Ctrl.text.trim()),
      ]);
    }
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
              'Xử lý sự cố',
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
    return LayoutHaveFloatingButton(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _resolveInfo(),
            SizedBox(
              height: 24.w,
            ),
            _electricityUnitInfo(),
            SizedBox(
              height: 24.w,
            ),
            _regionUnitInfo(),
            SizedBox(
              height: 24.w,
            ),
            _relatedUnitInfo()
          ],
        ),
      ),
    );
  }

  Widget _resolveInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin sự cố'.toUpperCase(),
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        SizedBox(
          height: 8.w,
        ),
        AppField(
          controller: _resolveNameCtrl,
          label: 'Tên sự cố:',
          autoFocus: true,
          nextFcNode: _resolveAddressNode,
          textInputAction: TextInputAction.next,
          hintText: 'Nhập tên sự cố',
        ),
        AppField(
          controller: _resolveAddressCtrl,
          label: 'Địa chỉ:',
          isName: true,
          fcNode: _resolveAddressNode,
          nextFcNode: _electricityUnit1Node,
          textInputAction: TextInputAction.next,
          hintText: 'Nhập địa chỉ',
        ),
      ],
    );
  }

  Widget _electricityUnitInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đơn vị quản lý vân hành lưới điện'.toUpperCase(),
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        SizedBox(
          height: 8.w,
        ),
        _personFieldWidget(
            ctrl1: _electricityUnit1Ctrl,
            ctrl2: _electricityUnitRole1Ctrl,
            fcNode1: _electricityUnit1Node,
            fcNode2: _electricityUnitRole1Node,
            nextFC: _electricityUnit2Node),
        _personFieldWidget(
            isRequired: false,
            ctrl1: _electricityUnit2Ctrl,
            ctrl2: _electricityUnitRole2Ctrl,
            fcNode1: _electricityUnit2Node,
            fcNode2: _electricityUnitRole2Node,
            nextFC: _regionUnit1Node),
      ],
    );
  }

  Widget _regionUnitInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chính quyền địa phương'.toUpperCase(),
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        SizedBox(
          height: 8.w,
        ),
        _personFieldWidget(
            ctrl1: _regionUnit1Ctrl,
            ctrl2: _regionUnitRole1Ctrl,
            fcNode1: _regionUnit1Node,
            fcNode2: _regionUnitRole1Node,
            isRequired: false,
            nextFC: _regionUnit2Node),
        _personFieldWidget(
            isRequired: false,
            ctrl1: _regionUnit2Ctrl,
            ctrl2: _regionUnitRole2Ctrl,
            fcNode1: _regionUnit2Node,
            fcNode2: _regionUnitRole2Node,
            nextFC: _relatedUnit1Node),
      ],
    );
  }

  Widget _relatedUnitInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tổ chức cá nhân liên quan'.toUpperCase(),
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        SizedBox(
          height: 8.w,
        ),
        _personFieldWidget(
            ctrl1: _relatedUnit1Ctrl,
            ctrl2: _relatedUnitRole1Ctrl,
            fcNode1: _relatedUnit1Node,
            fcNode2: _relatedUnitRole1Node,
            nextFC: _relatedUnit2Node),
        _personFieldWidget(
            isRequired: false,
            ctrl1: _relatedUnit2Ctrl,
            ctrl2: _relatedUnitRole2Ctrl,
            fcNode1: _relatedUnit2Node,
            fcNode2: _relatedUnitRole2Node),
      ],
    );
  }

  Widget _personFieldWidget(
      {required TextEditingController ctrl1,
      required TextEditingController ctrl2,
      required FocusNode fcNode1,
      required FocusNode fcNode2,
      bool isRequired = true,
      FocusNode? nextFC}) {
    return Row(
      children: [
        Expanded(
            child: AppField(
          controller: ctrl1,
          label: 'Ông/Bà:',
          isName: true,
          fcNode: fcNode1,
          isRequired: isRequired,
          nextFcNode: fcNode2,
          textInputAction: TextInputAction.next,
          hintText: 'Họ và tên',
        )),
        SizedBox(
          width: 8.w,
        ),
        Expanded(
            child: AppField(
          controller: ctrl2,
          label: 'Chức vụ:',
          isName: true,
          isRequired: isRequired,
          fcNode: fcNode2,
          nextFcNode: nextFC,
          textInputAction:
              nextFC != null ? TextInputAction.next : TextInputAction.done,
          hintText: 'Nhập chức vụ',
        )),
      ],
    );
  }
}
