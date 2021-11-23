import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_alert_dialog_widget.dart';

class SelectionDialog {
  static void show<T>(
      {required BuildContext context,
      required String title,
      required List<T> data,
      T? dataSelected,
      required Function(T) callback}) {
    showDialog(
        context: context,
        builder: (_) => RadioDialogWidget<T>(
              title: title,
              callbackSelect: callback,
              data: data,
              dataSelected: dataSelected,
            ));
  }
}

class RadioDialogWidget<T> extends StatefulWidget {
  RadioDialogWidget(
      {Key? key,
      required this.title,
      required this.data,
      required this.callbackSelect,
      this.dataSelected})
      : super(key: key);

  final String title;
  final List<T> data;
  final T? dataSelected;
  final Function(T) callbackSelect;

  @override
  _RadioDialogWidgetState<T> createState() => _RadioDialogWidgetState<T>();
}

class _RadioDialogWidgetState<T> extends State<RadioDialogWidget<T>> {
  late T _itemSelected;

  @override
  void initState() {
    _itemSelected = widget.dataSelected ?? widget.data[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppAlertDialogWidget(
      title: widget.title,
      contentPadding: EdgeInsets.only(top: 16.h),
      barrierDismissible: false,
      leftLabel: 'Hủy',
      callBackLeft: () => Navigator.pop(context),
      rightLabel: 'Chọn',
      callBackRight: () {
        widget.callbackSelect(_itemSelected);
        Navigator.pop(context);
      },
      content: _radiosWidget(),
    );
  }

  Widget _radiosWidget() {
    final len = widget.data.length;

    return SizedBox(
      width: double.maxFinite,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: len,
        itemBuilder: (context, index) {
          return _itemRadioWidget(widget.data[index]);
        },
      ),
    );
  }

  Widget _itemRadioWidget(T data) {
    final titleStyle = Theme.of(context).textTheme.bodyText1;

    return Padding(
      padding: EdgeInsets.only(top: 16.h, left: 24.w, right: 24.w),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            _itemSelected = data;
          });
        },
        child: Row(
          children: [
            SizedBox(
              height: 16.w,
              width: 16.w,
              child: Radio<T>(
                value: data,
                groupValue: _itemSelected,
                onChanged: (value) {
                  setState(() {
                    _itemSelected = data;
                  });
                },
              ),
            ),
            SizedBox(
              width: 16.w,
            ),
            Expanded(
              child: Text(
                data!.toString(),
                style: titleStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
