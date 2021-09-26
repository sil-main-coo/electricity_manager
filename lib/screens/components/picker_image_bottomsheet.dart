import 'package:flutter/material.dart';

import 'content_bottom_sheet_default.dart';


class PickerImageBottomSheet {
  static void show(
      {required BuildContext context,
        required Function cameraCallback,
        required Function galleryCallback}) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => PickerImageBottomSheetWidget(
        cameraCallback: cameraCallback,
        galleryCallback: galleryCallback,
      ),
    );
  }
}

class PickerImageBottomSheetWidget extends StatelessWidget {
  PickerImageBottomSheetWidget(
      {Key? key, required this.cameraCallback, required this.galleryCallback})
      : super(key: key);

  final Function cameraCallback;
  final Function galleryCallback;

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ButtonBottomSheetModel(
          label: 'Chụp ảnh',
          color: Colors.black,
          onPressed: () {
            cameraCallback();
            Navigator.pop(context);
          }),
      ButtonBottomSheetModel(
        label: 'Chọn từ thư viện ảnh',
        color: Colors.black,
        onPressed: () async {
          galleryCallback();
          Navigator.pop(context);
        },
      )
    ];

    return ContentBottomSheetDefault(
      title: 'Tùy chọn',
      buttons: buttons,
    );
  }
}