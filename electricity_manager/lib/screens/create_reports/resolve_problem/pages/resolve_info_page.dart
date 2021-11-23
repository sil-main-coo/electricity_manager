import 'package:electricity_manager/screens/components/app_field.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResolveInfoPage extends StatefulWidget {
  const ResolveInfoPage(
      {Key? key, required this.nextCallback, required this.backCallback})
      : super(key: key);

  final Function(String, String, String) nextCallback;
  final Function backCallback;

  @override
  _ResolveInfoPageState createState() => _ResolveInfoPageState();
}

class _ResolveInfoPageState extends State<ResolveInfoPage> {
  final _happeningCtrl = TextEditingController();
  final _sceneCtrl = TextEditingController();
  final _resolveReasonCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _next() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      widget.nextCallback(_happeningCtrl.text.trim(), _sceneCtrl.text.trim(),
          _resolveReasonCtrl.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => widget.backCallback(),
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
              'Thông tin sự cố',
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
              Text(
                'Diễn biến sự cố'.toUpperCase(),
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp),
              ),
              SizedBox(
                height: 8.w,
              ),
              SizedBox(
                height: 150.h,
                child: AppField(
                  controller: _happeningCtrl,
                  autoFocus: true,
                  isMultiLine: true,
                  keyboardType: TextInputType.multiline,
                  hintText: 'Tóm tắt diễn biến...',
                ),
              ),
              SizedBox(
                height: 24.w,
              ),
              Text(
                'Hiện trường sau sự cố'.toUpperCase(),
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp),
              ),
              SizedBox(
                height: 8.w,
              ),
              SizedBox(
                height: 150.h,
                child: AppField(
                  controller: _sceneCtrl,
                  autoFocus: true,
                  isMultiLine: true,
                  keyboardType: TextInputType.multiline,
                  hintText: 'Mô tả hiện trường sau sự cố...',
                ),
              ),
              SizedBox(
                height: 24.w,
              ),
              Text(
                'Nguyên nhân'.toUpperCase(),
                style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp),
              ),
              SizedBox(
                height: 8.w,
              ),
              SizedBox(
                height: 150.h,
                child: AppField(
                  controller: _resolveReasonCtrl,
                  autoFocus: true,
                  isMultiLine: true,
                  keyboardType: TextInputType.multiline,
                  hintText: 'Phán đoán nguyên nhân sự cố...',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
